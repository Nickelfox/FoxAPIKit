//
//  APIClient.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import Alamofire
import JSONParsing
import AnyErrorKit

private let AuthHeadersKey = "AuthHeadersKey"

public let DefaultStatusCode = 0

public typealias JSON = JSONParsing.JSON
public typealias AnyError = AnyErrorKit.AnyError

open class APIClient<U: AuthHeadersProtocol, V: ErrorResponseProtocol> {

	public var enableLogs = false
	
	public init() {
		self.networkManager = NetworkReachabilityManager()
		self.sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
		if let profileJSON = self.currentProfile {
			do {
				self.setAuthHeaders(try JSON(profileJSON)^)
			} catch {
				print("No saved auth headers found.")
			}
		}
	}
	
	private func setAuthHeaders(_ authHeaders: U?) {
		self.authHeaders = authHeaders
	}
	
	private var currentProfile: Any? {
		get {
			return UserDefaults.standard.object(forKey: AuthHeadersKey)
		} set {
			UserDefaults.standard.set(newValue, forKey: AuthHeadersKey)
			UserDefaults.standard.synchronize()
		}
	}

	public var authHeaders: U? = nil {
		didSet {
			guard let authHeaders = self.authHeaders else {
				self.sessionManager.adapter = nil
				return
			}
			self.sessionManager.adapter = authHeaders
			self.currentProfile = authHeaders.toJSON()
		}
	}

	public var isAuthenticated: Bool {
		if let headers = self.authHeaders {
			return headers.isValid
		}
		return false
	}
	
	fileprivate let sessionManager: SessionManager
	fileprivate let networkManager: NetworkReachabilityManager?
	
	fileprivate func parseAuthenticationHeaders (_ response: HTTPURLResponse) {
		self.authHeaders = self.authenticationHeaders(response: response)
	}

	//Override this method in the subclass to set auth headers from the responses.
	open func authenticationHeaders (response: HTTPURLResponse) -> U? {
		return nil
	}

	//Override this function to provide custom implementation of error parsing.
	open func parseError(_ json: JSON, _ statusCode: Int) -> AnyError {
		if let errorResponse = try? V.parse(json, code: statusCode) {
			return errorResponse
		} else {
			return APIClientError.unknown
		}
	}

	fileprivate var isNetworkReachable: Bool {
		guard let networkManager = self.networkManager  else {
			return false
		}
		return networkManager.isReachable
	}
	
	open func clearAuthHeaders() {
		self.authHeaders = nil
	}
	
}

//MARK: Offline Request
extension APIClient {
	public func request<T: JSONParseable> (_ urlRouter: URLRouter, completion: @escaping (_ result: APIResult<T>) -> Void) {
		if urlRouter.url.isFileURL {
			self.requestWithFileUrl(urlRouter, completion: completion)
		} else {
			self.request(urlRouter, completion: completion)
		}
	}
	
	fileprivate func requestWithFileUrl<T: JSONParseable> (_ urlRouter: URLRouter, completion: @escaping (_ result: APIResult<T>) -> Void) {
		let completionHandler: (_ result: APIResult<T>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		if self.enableLogs {
			print("Loading data from url: \(urlRouter.url.absoluteString)")
		}
		let queue: DispatchQueue = DispatchQueue(label: "url_load", attributes: [])
		queue.async {
			do {
				let data = try Data(contentsOf: urlRouter.url)
				if self.enableLogs {
					print("Response at Url: \(urlRouter.url.absoluteString)")
					print("\(String(data: data, encoding: .utf8) ?? ""))")
				}
				var error: NSError?
				let json = JSON.init(data: data, options: .allowFragments, error: &error)
				if error != nil {
					completionHandler(.failure(APIClientError.errorReadingUrl(urlRouter.url)))
					return
				}
				let result: T = try self.parse(json, router: urlRouter, 200)
				completionHandler(.success(result))
			} catch let error as AnyError {
				completionHandler(.failure(error))
			} catch {
				completionHandler(.failure(APIClientError.errorReadingUrl(urlRouter.url)))
			}
		}
	}

}

//MARK: JSON Request
extension APIClient {

	public func request<T: JSONParseable> (_ router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) {
		let _ = self.requestInternal(router: router, completion: completion)
	}

	fileprivate func requestInternal<T: JSONParseable> (router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) -> Request {
		
		//Make request
		let request = self.sessionManager.request(router)
		self.makeRequest(request: request, router: router, completion: completion)
		return request
	}
	
	fileprivate func makeRequest<T: JSONParseable> (request: DataRequest, router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) {
		
		let completionHandler: (_ result: APIResult<T>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		//Reachability Check
		if !self.isNetworkReachable {
			completionHandler(.failure(APIClientError.noInternet))
		}

		if self.enableLogs {
			request.log()
		}
		request.response { [weak self] response in
			guard let this = self else {
				completionHandler(.failure(APIClientError.unknown))
				return
			}
			if this.enableLogs {
				response.log()
			}
			
			func handleJson(_ json: JSON, code: Int) {
				if let httpResponse = response.response {
					//Parse Auth Headers
					this.parseAuthenticationHeaders(httpResponse)
				}
				do {
					let result: T = try this.parse(json, router: router, code)
					completionHandler(.success(result))
				} catch let apiError as AnyError {
					completionHandler(.failure(apiError))
				} catch {
					completionHandler(.failure(error as NSError))
				}
			}
			
			let code = response.response?.statusCode ?? DefaultStatusCode
			var json = JSON.null
			if let data = response.data {
				json = JSON(data: data)
			}
			if 200...299 ~= code {
				handleJson(json, code: code)
			} else {
				completionHandler(.failure(this.parseError(json, code)))
			}
		}
	}


}

//MARK: Multipart Request
extension APIClient {
	
	public func multipartRequest<T: JSONParseable> (
		_ router: Router,
		multipartFormData: @escaping (MultipartFormData) -> Void,
		completion: @escaping (_ result: APIResult<T>) -> Void) {
		
		self.multipartRequestInternal(
			router: router,
			multipartFormData: multipartFormData,
			completion: completion
		)
	}
	
	fileprivate func multipartRequestInternal<T: JSONParseable> (router: Router, multipartFormData: @escaping (MultipartFormData) -> Void, completion: @escaping (_ result: APIResult<T>) -> Void) {
		let completionHandler: (_ result: APIResult<T>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		//Make request
		self.sessionManager.upload(
		multipartFormData: multipartFormData, with: router) { [weak self] encodingResult in
			guard let this = self else {
				completionHandler(.failure(APIClientError.unknown))
				return
			}
			switch encodingResult {
			case .success(let upload, _, _):
				this.makeRequest(request: upload, router: router, completion: completion)
			case .failure(let encodingError):
				completionHandler(.failure(this.parseError(encodingError as NSError?)))
			}
		}
	}


}

extension APIClient {
	
	fileprivate func parse<T: JSONParseable> (_ json: JSON, router: Router, _ statusCode: Int) throws -> T {
		do {
			//try parsing error response
			if let errorResponse = try? V.parse(json, code: statusCode) {
				throw errorResponse
			}
			var jsonToParse = json
			//if map keypath is provided then try to map data at that keypath
			if let keypathToMap = router.keypathToMap {
				jsonToParse = json.jsonAtKeyPath(keypath: keypathToMap)
			}
			return try T.parse(jsonToParse)
		} catch let apiError as AnyError {
			throw apiError
		} catch let error as NSError {
			throw error
		} catch {
			throw APIClientError.unknown
		}
	}
	
	fileprivate func parseError(_ error: NSError?) -> AnyError {
		if let error = error {
			return error
		} else {
			return APIClientError.unknown
		}
	}

}

extension Request {

	func log() {
		if let request = self.request,
			let url = request.url,
			let headers = request.allHTTPHeaderFields,
			let method = request.httpMethod {
			print("Request: \(method) \(url)")
			print("Headers: \(headers)")
			if let data = request.httpBody, let params = String.init(data: data, encoding: .utf8) {
				print("Params: \(params)")
			}
		}
	}
	
}


extension DefaultDataResponse {

	func log() {
		if let response = self.response,
			let data = self.data,
			let utf8 = String.init(data: data, encoding: .utf8),
			let url = self.request?.url {
			let statusCode = response.statusCode
			print("Response for \(url):")
			print("Status Code: \(statusCode)")
			print("Data: \(utf8)")
		}
	}

	
}
