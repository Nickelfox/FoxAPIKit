 //
//  Paginator.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

public protocol Pageable: JSONParseable {
	static func fetch(router: PageRouter, completion: @escaping (_ result: APIResult<PageResponse>) -> Void)
}

public protocol PageRouter: Router {
	var pageInfoKeypath: String? { get }
	var objectsKeypath: String? { get }
}

private let defaultPageSize: Int = 20

private func += <K, V> (left: inout [K:V], right: [K:V]?) {
	guard  let right = right else { return }
	for (k, v) in right {
		left[k] = v
	}
}

struct PageRequest<T: PageMetaData>: PageRouter {
	
	let currenPageMetaData: T?
	let router: PageRouter
	let index: Int
	let limit: Int
	
	var params: [String: Any] {
		var params: [String: Any] = self.router.params
		let pageParams = T.nextPageParams(
			currentIndex: self.index,
			limit: self.limit,
			currentPageMetaData: self.currenPageMetaData
		)
		params += pageParams
		return params
	}
	
	var method: HTTPMethod { return self.router.method }
	
	var keypathToMap: String? { return self.router.keypathToMap }
	
	var headers: [String : String]  { return self.router.headers }
	
	var baseUrl: URL { return self.router.baseUrl }
	
	var path: String { return self.router.path }
	
	var timeoutInterval: TimeInterval? { return router.timeoutInterval }
	
	var encoding: URLEncoding? { return self.router.encoding }
	
	var pageInfoKeypath: String? { return self.router.pageInfoKeypath }
	
	var objectsKeypath: String? { return self.router.objectsKeypath }

}

public class Paginator<T: Pageable, U: PageMetaData> {

	fileprivate(set) public var items: [T] = []
	fileprivate(set) public var currentIndex: Int
	fileprivate(set) public var currentPageMetaData: U? = nil
	fileprivate(set) public var canLoadMore = true
	
	public let router: PageRouter
	public let limit: Int
	
	public init(router: PageRouter, limit: Int = defaultPageSize) {
		self.currentIndex = 0
		self.limit = limit
		self.router = router
	}
	
	fileprivate func loadNextPage(isFirst: Bool, completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		let router = PageRequest<U>(
			currenPageMetaData: self.currentPageMetaData,
			router: self.router,
			index: self.currentIndex,
			limit: self.limit
		)

		T.fetch(router: router) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success(let pageResponse):
				do {
					let paginationResponse = try PaginationResponse<T,U>.parse(pageResponse.json, pageInfoKeypath: router.pageInfoKeypath, objectsKeypath: router.objectsKeypath)
					
					if isFirst {
						this.items.removeAll()
					}
					for item in paginationResponse.objects {
						this.items.append(item)
					}
	
					this.currentPageMetaData = paginationResponse.pageMetaData
					this.canLoadMore = paginationResponse.objects.count >= this.limit
					if this.canLoadMore {
						this.currentIndex += 1
					}
					completion(.success(paginationResponse.objects))
				} catch let error as AnyError {
					completion(.failure(error))
				} catch {
					completion(.failure(APIClientError.unknown))
				}
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	public func refresh(completion: @escaping (_ result: APIResult<[T]>) -> Void) {
		self.currentIndex = 0
		self.loadNextPage(isFirst: true, completion: completion)
	}
	
	public func loadNext(completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		self.loadNextPage(isFirst: false, completion: completion)
	}

}

public protocol PageMetaData: JSONParseable {
	static func nextPageParams(currentIndex: Int, limit: Int, currentPageMetaData: Self?) -> [String: Any]
}

public struct PageResponse: JSONParseable {
	let json: JSON
	
	public static func parse(_ json: JSON) throws -> PageResponse {
		return PageResponse(json: json)
	}
}



public final class PaginationResponse<T: Pageable, U: PageMetaData> {
	
	public var objects: [T]
	public var pageMetaData: U?
	
	public init(objects: [T], pageMetaData: U?) throws {
		self.objects = objects
		self.pageMetaData = pageMetaData
	}
	
}

extension PaginationResponse {
	
	public static func parse(_ json: JSON, pageInfoKeypath: String?, objectsKeypath: String?) throws -> PaginationResponse {
		var paginationJSON = json
		if let pageInfoKeypath = pageInfoKeypath {
			paginationJSON = json.jsonAtKeyPath(keypath: pageInfoKeypath)
		}
		var jsonList = json.arrayValue
		if let objectsKeypath = objectsKeypath {
			jsonList = json.jsonAtKeyPath(keypath: objectsKeypath).arrayValue
		}
		var objects: [T] = []
		for jsonObject in jsonList {
			do {
				let object = try T.parse(jsonObject)
				objects.append(object)
				
			} catch {
				throw error
			}
		}
		return try PaginationResponse(
			objects: objects,
			pageMetaData: paginationJSON^?
		)
	}
}



