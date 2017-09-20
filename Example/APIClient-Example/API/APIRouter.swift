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
	
	case fetchNumbers
	
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
		case .fetchNumbers:
			var numbers: [[String: Any]] = []
			for i in 1...20 {
				numbers.append(["value": i])
			}
			return ["numbers": numbers]
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


