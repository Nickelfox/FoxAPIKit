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

public class Paginator<T: Pageable, U: JSONParseable> {

    public typealias PaginationRouterBlock = (PageRouter?, U?) -> PageRouter
    
	fileprivate(set) public var items: [T] = []
	fileprivate(set) public var currentIndex: Int
	fileprivate(set) public var currentPageMetaData: U?
	fileprivate(set) public var canLoadMore = true
    fileprivate var paginationRouterBlock: PaginationRouterBlock
	fileprivate var currentRouter: PageRouter?
    
	public let limit: Int
	
	public init(limit: Int = defaultPageSize, paginationRouterBlock: @escaping PaginationRouterBlock) {
		self.currentIndex = 0
		self.limit = limit
        self.paginationRouterBlock = paginationRouterBlock
	}
	
	fileprivate func loadNextPage(isFirst: Bool, completion:  @escaping (_ result: APIResult<[T]>) -> Void) {

		self.currentRouter = self.paginationRouterBlock(self.currentRouter, self.currentPageMetaData)
        let router = self.currentRouter!
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

public struct PageResponse: JSONParseable {
	let json: JSON
	
	public static func parse(_ json: JSON) throws -> PageResponse {
		return PageResponse(json: json)
	}
}



public final class PaginationResponse<T: Pageable, U: JSONParseable> {
	
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



