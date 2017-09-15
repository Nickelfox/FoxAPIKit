 //
//  Paginator1.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

private let defaultPageSize: Int = 20

//public protocol Pageable1: JSONParseable {
//	associatedtype T: JSONParseable
//	associatedtype U: PageInfo
//	associatedtype V: PaginationInfoMapper
//	
//	static func fetch(router: Router, completion: @escaping (_ result: APIResult<PaginationResponse<T, U, V>>) -> Void)
//}
//
//public class Paginator1<T: Pageable1, U: PageInfo, V: PaginationInfoMapper> {
//	public var items: [T] = []
//	public var currentIndex: Int
//	public var currentPageInfo: U?
//	public var canLoadMore = true
//	public let router: Router
//	public let limit: Int
//	
//	public init(router: Router, limit: Int = defaultPageSize) {
//		self.currentIndex = 0
//		self.limit = limit
//		self.router = router
//	}
//	
//	public func loadNextPage(completion:  @escaping (_ result: APIResult<[T]>) -> Void) {
//		
//		let request = PageRequest(router: self.router, index: self.currentIndex, limit: self.limit)
//		
//		T.fetch(router: request) { [weak self] result in
//			guard let this = self else { return }
//			switch result {
//			case .success(let response):
////				for item in response.objects {
//////					this.items.append(item)
////				}
////				this.currentPageInfo = response.pageInfo as! _
//				this.canLoadMore = response.pageInfo.count >= this.limit
//				if this.canLoadMore {
//					this.currentIndex += 1
//				}
//			case .failure(let error): completion(.failure(error))
//			}
//		}
//		
////		T.fetch(router: request) { [weak self] (result: APIResult<[T]>) in
////			guard let this = self else { return }
////			switch result {
////			case .success(let items):
////				for item in items {
////					this.items.append(item)
////				}
////				this.canLoadMore = items.count >= this.limit
////				if this.canLoadMore {
////					this.currentIndex += 1
////				}
////			case .failure(let error): completion(.failure(error))
////			}
////		}
//	}
//	
//	public func refresh(completion: @escaping (_ result: APIResult<[T]>) -> Void) {
//		self.currentIndex = 0
//		self.items.removeAll()
//		self.loadNextPage(completion: completion)
//	}
//}

//struct PageRequest: Router {
//	
//	let router: Router
//	let index: Int
//	let limit: Int
//	
//	var params: [String: Any] {
//		return self.router.compiledParams(index: self.index, limit: self.limit)
//	}
//	
//	var method: HTTPMethod { return self.router.method }
//	
//	var keypathToMap: String? { return self.router.keypathToMap }
//	
//	var headers: [String : String]  { return self.router.headers }
//	
//	var baseUrl: URL { return self.router.baseUrl }
//	
//	var path: String { return self.router.path }
//	
//	var timeoutInterval: TimeInterval? { return router.timeoutInterval }
//	
//	var encoding: URLEncoding? { return self.router.encoding }
//	
//}
