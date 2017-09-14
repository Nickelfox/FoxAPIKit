//
//  PageRequest.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public class PageRequest: Router {
	
	public let index: Int
	public let limit: Int
	public let router: Router
	
	public init(router: Router, index: Int, limit: Int) {
		self.index = index
		self.limit = limit
		self.router = router
	}
	
	public var params: [String: Any] {
		return self.router.compiledParams(index: self.index, limit: self.limit)
	}

	public var method: HTTPMethod { return self.router.method }
	
	public var keypathToMap: String? { return self.router.keypathToMap }
	
	public var headers: [String : String]  { return self.router.headers }
	
	public var baseUrl: URL { return self.router.baseUrl }
	
	public var path: String { return self.router.path }
	
	public var timeoutInterval: TimeInterval? { return router.timeoutInterval }
	
	public var encoding: URLEncoding? { return self.router.encoding }

}
