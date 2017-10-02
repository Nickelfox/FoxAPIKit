//
//  CursorPageRouter.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 02/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import APIClient
import JSONParsing
import CoreLocation

let token = "Add your FB token here"

public struct FBPageMetaData: PageMetaData {
	public var nextUrl: String
	
	public static func parse(_ json: JSON) throws -> FBPageMetaData {
		return try FBPageMetaData(nextUrl: json["next"]^)
	}
	
	public static func nextPageParams(currentIndex: Int, limit: Int, currentPageMetaData: FBPageMetaData?) -> [String : Any] {
		return [:]
	}
}

enum CursorPageRouter1: PageRouter {

	case fetchNumbers
	case fetchNumbersWithUrl(String?)
	
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
		return .get
	}
	
	public var path: String {
		switch self {
		case .fetchNumbers:
			return "search"
		default: return ""
		}
		
	}
	
	public var params: [String: Any] {
		switch self {
		case .fetchNumbers:
			return ["access_token": token,
			        "fields": "name",
			        "type": "place",
			        "center": "40.7304,-73.9921",
			        "distance": 1000,
			        "limit": 20
			]
		default: return [:]
		}
	}
	
	var objectsKeypath: String? {
		return "data"
	}
	
	var pageInfoKeypath: String? {
		return "paging"
	}
	
	public var baseUrl: URL {
		let baseURL = URL(string: "https://graph.facebook.com/v2.10/")!
		switch self {
		case .fetchNumbers:
			return baseURL
		case .fetchNumbersWithUrl(let url):
			return URL(string: url!)!
		}
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}

}
