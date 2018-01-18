//
//  PaginationAPIRouter.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import FoxAPIKit
import JSONParsing

struct PaginationMetaData: PaginationMetaDataProtocol {
	
	var page: Int
	var limit: Int
	var next: String
	
	static func parse(_ json: JSON) throws -> PaginationMetaData {
		return try PaginationMetaData(page: json["page"]^, limit: json["limit"]^, next: json["next"]^!)
	}
	
}

enum APIPageRouter: PaginationRouter {
	
	case fetchNumbers(page: Int, limit: Int)
	
	var keypathToMap: String? {
		return "args"
	}
	
	var timeoutInterval: TimeInterval? {
		return nil
	}
	
	var encoding: URLEncoding? {
		return nil
	}
	
	public var method: HTTPMethod {
		switch self {
		case .fetchNumbers:
			return .get
		}
	}
	
	public var path: String {
		switch self {
		case .fetchNumbers:
			return "/get"
		}
	}
	
	public var params: [String: Any] {
		switch self {
		case .fetchNumbers(let page, let limit):
			var numbers: [[String: Any]] = []
			for i in 1...20 {
				numbers.append(["value": i])
			}
			var params: [String: Any] = ["numbers": numbers]
			params["page"] =  page
			params["limit"] =  limit
			return params
		}
	}
	
	var objectsKeypath: String? {
		return "numbers[][value]"
	}
	
	var pageInfoKeypath: String? {
		return nil
	}
	
	public var baseUrl: URL {
		let baseURL = URL(string: "https://httpbin.org")!
		return baseURL
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}
	
}
