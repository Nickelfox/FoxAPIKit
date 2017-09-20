//
//  CursorPaginator.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

private let defaultPageSize: Int = 20

public protocol CursorPageRouter: URLRouter, PageRouter {}

public protocol CursorPageMetaData: JSONParseable {
	static func nextPageUrl(currentIndex: Int, limit: Int, currentPageMetaData: Self?) -> URL?
}

public class CursorPaginator<T: Pageable, U: CursorPageMetaData> {
	
	fileprivate(set) public var items: [T] = []
	fileprivate(set) public var currentIndex: Int
	fileprivate(set) public var currentPageMetaData: U? = nil
	fileprivate(set) public var canLoadMore = true
	
	public let router: CursorPageRouter
	public let limit: Int
	
	public init(router: CursorPageRouter, limit: Int = defaultPageSize) {
		self.currentIndex = 0
		self.limit = limit
		self.router = router
	}
	
	fileprivate func loadNextPage(isFirst: Bool, completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		guard let url = U.nextPageUrl(currentIndex: self.currentIndex,
		                              limit: self.limit,
		                              currentPageMetaData: self.currentPageMetaData
			) else {
				//TODO: throw something to show no more data
				return
		}
		
		let router = CursorPageRequest1(url: url,
		                                router: self.router
		)
		T.fetch(router: router) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success(let pageResponse):
				do {
					let paginationResponse = try CursorPaginationResponse<T,U>.parse(pageResponse.json, pageInfoKeypath: router.pageInfoKeypath, objectsKeypath: router.objectsKeypath)
					
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

public final class CursorPaginationResponse<T: Pageable, U: CursorPageMetaData> {
	
	public var objects: [T]
	public var pageMetaData: U?
	
	public init(objects: [T], pageMetaData: U?) throws {
		self.objects = objects
		self.pageMetaData = pageMetaData
	}
	
}

extension CursorPaginationResponse {
	
	public static func parse(_ json: JSON, pageInfoKeypath: String?, objectsKeypath: String?) throws -> CursorPaginationResponse {
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
		return try CursorPaginationResponse(
			objects: objects,
			pageMetaData: paginationJSON^?
		)
	}
}


struct CursorPageRequest1: CursorPageRouter {
	
	let url: URL
	let router: CursorPageRouter
	
	var pageInfoKeypath: String? { return self.router.pageInfoKeypath }
	
	var objectsKeypath: String? { return self.router.objectsKeypath }
	
	
}


