 //
//  Paginator1.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

public protocol Pageable1: JSONParseable {
	associatedtype U: JSONParseable
	associatedtype V: PaginationInfoMapper
	
	static func fetch<U: JSONParseable,V: PaginationInfoMapper>(router: Router, completion: @escaping (_ result: APIResult<PaginationResponse<Self, U, V>>) -> Void)
}

private let defaultPageSize: Int = 20

public class Paginator<T: Pageable1, U: JSONParseable, V: PaginationInfoMapper>{

	public var items: [T] = []
	public var currentIndex: Int
	public var pageInfo: U?
	public var canLoadMore = true
	public let router: Router
	public let limit: Int
	
	public init(router: Router, limit: Int = defaultPageSize) {
		self.currentIndex = 0
		self.limit = limit
		self.router = router
	}
	
	private func loadNextPage(isFirst: Bool, completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		self.fetch(router: self.router) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success(let response):
				if isFirst {
					this.items.removeAll()
				}
				for item in response.objects {
					this.items.append(item)
				}
				
				this.pageInfo = response.pageInfo
				this.canLoadMore = response.objects.count >= this.limit
				if this.canLoadMore {
					this.currentIndex += 1
				}
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	private func fetch(router: Router, completion: @escaping (_ result: APIResult<PaginationResponse<T, U, V>>) -> Void) {
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
