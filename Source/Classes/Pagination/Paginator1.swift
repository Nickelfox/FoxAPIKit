 //
//  Paginator1.swift
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
	func router(currentIndex: Int, limit: Int, currentPageMetaData: PageMetaData?) -> PageRouter
}

private let defaultPageSize: Int = 20

public class Paginator<T: Pageable, U: PageMetaData> {

	private(set) public var items: [T] = []
	private(set) public var currentIndex: Int
	private(set) public var currentPageMetaData: U? = nil
	private(set) public var canLoadMore = true
	
	public let router: PageRouter
	public let limit: Int
	
	public init(router: PageRouter, limit: Int = defaultPageSize) {
		self.currentIndex = 0
		self.limit = limit
		self.router = router
	}
	
	private func loadNextPage(isFirst: Bool, completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		let router = self.router.router(currentIndex: self.currentIndex, limit: self.limit, currentPageMetaData: self.currentPageMetaData)
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
//		self.fetch(router: router) { [weak self] (result) in
//			guard let this = self else { return }
//			switch result {
//			case .success(let response):
//				if isFirst {
//					this.items.removeAll()
//				}
//				for item in response.objects {
//					this.items.append(item)
//				}
//				
//				this.currentPageMetaData = response.pageMetaData
//				this.canLoadMore = response.objects.count >= this.limit
//				if this.canLoadMore {
//					this.currentIndex += 1
//				}
//			case .failure(let error): completion(.failure(error))
//			}
//		}
	}
	
//	private func fetch(router: PageRouter, completion: @escaping (_ result: APIResult<U>) -> Void) {
//		T.fetch(router: router, completion: completion)
//	}

	public func refresh(completion: @escaping (_ result: APIResult<[T]>) -> Void) {
		self.currentIndex = 0
		self.loadNextPage(isFirst: true, completion: completion)
	}
	
	public func loadNext(completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		self.loadNextPage(isFirst: false, completion: completion)
	}

}
