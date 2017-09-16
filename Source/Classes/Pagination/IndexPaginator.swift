//
//  IndexPaginator.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

private let defaultPageSize: Int = 20
private let firstIndex: Int = 0

public protocol Pageable: JSONParseable {
	static func fetch(router: Router, completion: @escaping (_ result: APIResult<[Self]>) -> Void)
}

public enum IndexPaginatorType {
	case pageBased
	case offsetBased
}

public struct IndexPageInfo<T: Pageable> {
	public var objects: [T]
	public var hasMoreDataToLoad: Bool
	public var paginator: IndexPaginator<T>
}

public class IndexPaginator<T: Pageable> {
	public var items: [T] = []
	public var currentIndex: Int
	public var canLoadMore = true
	public let router: Router
	public let limit: Int
	public let initialIndex: Int
	public let paginatorType: IndexPaginatorType
	
	private(set) public var loading: Bool = false
	
	deinit {
		print("Index Paginator Deinit")
	}
	
	public init(
		router: Router,
		initialIndex: Int = firstIndex,
		limit: Int = defaultPageSize,
		paginatorType: IndexPaginatorType = .pageBased) {
		self.currentIndex = initialIndex
		self.initialIndex = initialIndex
		self.limit = limit
		self.router = router
		self.paginatorType = paginatorType
	}
	
	public func loadNextPage(completion:  @escaping (_ result: APIResult<IndexPageInfo<T>>) -> Void) {
		if self.loading {
			completion(.failure(PaginatorError.alreadyLoading))
			return
		}
		
		self.loading = true
		let request = PageRequest(router: self.router, index: self.currentIndex, limit: self.limit)
		T.fetch(router: request) { [weak self] (result: APIResult<[T]>) in
			guard let this = self else { return }
			this.loading = false
			switch result {
			case .success(let items):
				if this.currentIndex == this.initialIndex {
					this.items.removeAll()
				}
				for item in items {
					this.items.append(item)
				}
				this.canLoadMore = items.count >= this.limit
				if this.canLoadMore {
					switch this.paginatorType {
					case .offsetBased: this.currentIndex += items.count
					case .pageBased: this.currentIndex += 1
					}
				}
				let pageInfo = IndexPageInfo(objects: items, hasMoreDataToLoad: this.canLoadMore, paginator: this)
				completion(.success(pageInfo))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	public func refresh(completion: @escaping (_ result: APIResult<IndexPageInfo<T>>) -> Void) {
		if self.loading {
			completion(.failure(PaginatorError.alreadyLoading))
			return
		}
		self.currentIndex = self.initialIndex
		self.loadNextPage(completion: completion)
	}
}

struct PageRequest: Router {
	
	let router: Router
	let index: Int
	let limit: Int
	
	var params: [String: Any] {
		return self.router.compiledParams(index: self.index, limit: self.limit)
	}
	
	var method: HTTPMethod { return self.router.method }
	
	var keypathToMap: String? { return self.router.keypathToMap }
	
	var headers: [String : String]  { return self.router.headers }
	
	var baseUrl: URL { return self.router.baseUrl }
	
	var path: String { return self.router.path }
	
	var timeoutInterval: TimeInterval? { return router.timeoutInterval }
	
	var encoding: URLEncoding? { return self.router.encoding }
	
}
