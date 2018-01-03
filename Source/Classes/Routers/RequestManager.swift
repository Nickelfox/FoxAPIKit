//
//  RequestManager.swift
//  APIClient
//
//  Created by Ravindra Soni on 19/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

open class RequestManager {

    public static let defaultParams: [String: Any] = [:]
	private static let defaultHeaders: [String: String] = [:]
	private static let defaultEncoding: URLEncoding = URLEncoding.default
	private static let defaultTimeout: TimeInterval = DefaultTimeoutInterval
	
	public let baseUrl: URL
	public var headers: [String: String] = RequestManager.defaultHeaders
	public var encoding: URLEncoding = RequestManager.defaultEncoding
	public var timeoutInterval: TimeInterval = RequestManager.defaultTimeout
	public var keypathToMap: String? = nil

	public init(baseUrl: URL) {
		self.baseUrl = baseUrl
	}

	public func get(
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return self.request(
			method: .get,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers,
			encoding: encoding,
			timeoutInterval: timeoutInterval
		)
	}

	public func post(
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return self.request(
			method: .post,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers,
			encoding: encoding,
			timeoutInterval: timeoutInterval
		)
	}

	public func put(
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return self.request(
			method: .put,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers,
			encoding: encoding,
			timeoutInterval: timeoutInterval
		)
	}

	public func patch(
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return self.request(
			method: .patch,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers,
			encoding: encoding,
			timeoutInterval: timeoutInterval
		)
	}

	public func delete(
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return self.request(
			method: .delete,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers,
			encoding: encoding,
			timeoutInterval: timeoutInterval
		)
	}

	public func request(
		method: HTTPMethod, 
		path: String,
		params: [String: Any] = RequestManager.defaultParams,
		keypathToMap: String? = nil,
		headers: [String: String]? = nil,
		encoding: URLEncoding? = nil,
		timeoutInterval: TimeInterval? = nil) -> Router {
		return APIRequest(
			baseUrl: self.baseUrl,
			method: method,
			path: path,
			params: params,
			keypathToMap: keypathToMap,
			headers: headers ?? self.headers,
			encoding: encoding ?? self.encoding,
			timeoutInterval: timeoutInterval ?? self.timeoutInterval
		)
	}
	
}
