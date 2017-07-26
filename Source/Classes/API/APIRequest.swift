//
//  APIRequest.swift
//  APIClient
//
//  Created by Ravindra Soni on 20/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public struct APIRequest: Router {
	
	public let baseUrl: URL
	public let method: HTTPMethod
	public let path: String
	public let params: [String: Any]
	public let headers: [String: String]
	public let encoding: URLEncoding?
	public let timeoutInterval: TimeInterval?
	public let keypathToMap: String?
	
	public init(baseUrl: URL, method: HTTPMethod, path: String, params: [String: Any] = [:], keypathToMap: String? = nil, headers: [String: String] = [:], encoding: URLEncoding? = nil, timeoutInterval: TimeInterval? = nil) {
		self.baseUrl = baseUrl
		self.method = method
		self.path = path
		self.params = params
		self.headers = headers
		self.encoding = encoding
		self.timeoutInterval = timeoutInterval
		self.keypathToMap = keypathToMap
	}
	
}
