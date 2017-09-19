//
//  APIRouter.swift
//  Inito
//
//  Created by Ravindra Soni on 24/10/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import APIClient

enum APIRouter: Router {
	
	case demo
	case fetchNumbers

	var keypathToMap: String? {
		switch self {
		case .demo:
			return "args"
		case .fetchNumbers:
			return "args.numbers[][value]"
		}
	}
	
	var timeoutInterval: TimeInterval? {
		return nil
	}
	
	var encoding: URLEncoding? {
		return nil
	}
	
	public var method: HTTPMethod {
		switch self {
		case .demo:
			return .get
		case .fetchNumbers:
			return .get
		}
	}
	
	public var path: String {
		switch self {
		case .demo:
			return "/get"
		case .fetchNumbers:
			return "/get"
		}
	}
	
	public var params: [String: Any] {
		switch self {
		case .demo:
			return ["id":"1"]
		case .fetchNumbers:
			var numbers: [[String: Any]] = []
			for i in 1...20 {
				numbers.append(["value": i])
			}
			return ["numbers": numbers]
		}
	}
	
	func pageParams(index: Int, limit: Int) -> [String : Any]? {
		return ["page": index, "limit": limit]
	}
	
	public var baseUrl: URL {
		let baseURL = URL(string: "https://httpbin.org")!
		return baseURL
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}
	
}


enum APIPageRouter: PageRouter {
	
	case fetchNumbers(currentIndex: Int, limit: Int, currentPageMetaData: PageMetaData?)
	
	var keypathToMap: String? {
		return nil
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
		case .fetchNumbers(let currentIndex, let limit, let currentPageMetaData):
			var numbers: [[String: Any]] = []
			for i in 1...20 {
				numbers.append(["value": i])
			}
			var params: [String : Any] = ["numbers": numbers]
			params["index"] = currentIndex + 1
			params["limit"] = limit
			if currentPageMetaData != nil {
				params["md"] = true
			}
			return params
		}
	}
	
	var objectsKeypath: String? {
		return "args.numbers[][value]"
	}
	
	var pageInfoKeypath: String? {
		return nil
	}
	
	func router(currentIndex: Int, limit: Int, currentPageMetaData: PageMetaData?) -> PageRouter {
			return APIPageRouter.fetchNumbers(currentIndex: currentIndex, limit: limit, currentPageMetaData: currentPageMetaData)
	}
	
	public var baseUrl: URL {
		let baseURL = URL(string: "https://httpbin.org")!
		return baseURL
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}
	
}


