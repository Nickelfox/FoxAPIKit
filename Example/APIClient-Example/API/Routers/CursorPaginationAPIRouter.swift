//
//  CursorPaginationAPIRouter.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import APIClient
import JSONParsing
import CoreLocation

let token = "EAACEdEose0cBAFItjhLlG3i9LlY6cV4UJtY7DWeYpiS51DGX9R6xVlbGiFkz17ZCyxLGZBbY35Vs0P82l0Q6gzJNDylVG4JxqWYVZBenjFOpUDmZCIutzm6LX31M73ruMAcYOtx5LtUGCn5KWDuNoH7ZCN5S4BWakZBeeWVtj27JrMZCTLp2FC6guSkqGLbwn8ZD"

public struct FBPageMetaData: PaginationMetaDataProtocol {
	public var nextUrl: String
	
	public static func parse(_ json: JSON) throws -> FBPageMetaData {
		return try FBPageMetaData(nextUrl: json["next"]^)
	}
}

enum H: URLRouter, PaginationRouter {

	case fetchNumbersWithUrl(String)
	

	var url: URL {
		switch self {
		case .fetchNumbersWithUrl(let urlString):
			return URL(string: urlString)!
		}
	}
	
	var objectsKeypath: String? {
		return "data"
	}
	
	var pageInfoKeypath: String? {
		return "paging"
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}

	
}

enum CursorPageRouter: PaginationRouter {
	
	case fetchNumbers
	
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
		return baseURL
	}
	
	public var headers: [String: String] {
		return ["Content-Type": "application/json"]
	}
	
}
