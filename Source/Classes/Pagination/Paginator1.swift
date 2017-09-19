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
	static func fetch<U: PaginationResponseProtocol>(router: PageRouter, completion: @escaping (_ result: APIResult<U>) -> Void)
}

public protocol PageRouter: Router {
	func router(currentIndex: Int, limit: Int, currentPageMetaData: PageMetaData?) -> PageRouter
}

private let defaultPageSize: Int = 20

public class Paginator<T: Pageable, U: PaginationResponseProtocol, V: PageMetaData> where U.Element == T {

	private(set) public var items: [T] = []
	private(set) public var currentIndex: Int
	private(set) public var currentPageMetaData: U.MetaData?
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
		self.fetch(router: router) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success(let response):
				if isFirst {
					this.items.removeAll()
				}
				for item in response.objects {
					this.items.append(item)
				}
				
				this.currentPageMetaData = response.pageMetaData
				this.canLoadMore = response.objects.count >= this.limit
				if this.canLoadMore {
					this.currentIndex += 1
				}
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	private func fetch(router: PageRouter, completion: @escaping (_ result: APIResult<U>) -> Void) {
		T.fetch(router: router, completion: completion)
	}

	public func refresh(completion: @escaping (_ result: APIResult<[T]>) -> Void) {
		self.currentIndex = 0
		self.loadNextPage(isFirst: true, completion: completion)
	}
	
	public func loadNext(completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		self.loadNextPage(isFirst: false, completion: completion)
	}

}
