//
//  Paginator.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

public let defaultPageSize: Int = 20

public protocol Pageable: JSONParseable {
	static func fetch(request: PageRequest, completion: @escaping (_ result: APIResult<ListResponse<Self>>) -> Void)
}

public class Paginator<T: Pageable> {
	public var items: [T] = []
	public var currentIndex: Int
	public var canLoadMore = true
	public let router: Router
	public let limit: Int
	
	public init(router: Router, limit: Int = defaultPageSize) {
		self.currentIndex = 0
		self.limit = limit
		self.router = router
	}
	
	public func loadNextPage(completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
		let request = PageRequest(router: self.router, index: self.currentIndex, limit: self.limit)
		T.fetch(request: request) { [weak self] (result: APIResult<ListResponse<T>>) in
			guard let this = self else { return }
			switch result {
			case .success(let listResponse):
				for item in listResponse.list {
					this.items.append(item)
				}
				this.canLoadMore = listResponse.list.count >= this.limit
				if this.canLoadMore {
					this.currentIndex += 1
				}
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	public func refresh(completion: @escaping (_ result: APIResult<[T]>) -> Void) {
		self.currentIndex = 0
		self.items.removeAll()
		self.loadNextPage(completion: completion)
	}
}
