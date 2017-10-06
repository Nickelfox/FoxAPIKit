//
//  APIRouter.swift
//  Inito
//
//  Created by Ravindra Soni on 24/10/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import APIClient

//https://graph.facebook.com/v2.10/search?access_token=EAACEdEose0cBAKcmJdaAo0H5vacoanPs7VQ3PBC6Wm8oN5RbWdvBDTbcvjPDqWMUzfP8KcpydkBx2663ZAGBxASv7wwTyxj9zdiHC9Y4O8e3AycyqQFTaZAHuTihsuWvneEwoUbN2KIyeRUjPuXstPj5JAXu3C8AO6dr43o7myKpEoZCVH58Tj7Vr5khTEZD&pretty=0&fields=name%2Ccheckins%2Cpicture&q=cafe&type=place&center=40.7304%2C-73.9921&distance=1000&limit=25&after=MjQZD"
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

