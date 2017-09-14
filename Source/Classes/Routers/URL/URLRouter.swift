//
//  URLRouter.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public protocol URLRouter: Router {
	var url: URL { get }
}

extension URLRouter {
	public var method: HTTPMethod {
		return .get
	}
	
	public var path: String {
		return ""
	}
	
	public var params: [String: Any] {
		return [:]
	}
	
	public var baseUrl: URL {
		return self.url
	}
	
	public var headers: [String: String] {
		return [:]
	}
	
}

