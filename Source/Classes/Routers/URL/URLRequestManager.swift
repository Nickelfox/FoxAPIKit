//
//  URLRequestManager.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public struct URLAPIRequest: URLRouter {
	
	public let url: URL
	
	public init(url: URL) {
		self.url = url
	}
	
}

open class URLRequestManager {
	
	public init() {}
	
	public func request(url: URL) -> URLRouter {
		return URLAPIRequest(url: url)
	}
	
}
