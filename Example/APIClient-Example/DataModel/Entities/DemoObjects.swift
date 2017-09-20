//
//  DemoObject.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing
import APIClient

enum Test: Int, JSONParseRawRepresentable {
	typealias RawValue = Int
	case one = 1
	case two = 2
}

public struct DemoObject: CustomStringConvertible {
	let value: Test
	
	public var description: String {
		return "value: \(self.value)"
	}
}

extension DemoObject: JSONParseable {
	public static func parse(_ json: JSON) throws -> DemoObject {
		return try DemoObject(
			value: json["id"]^
		)
	}
	
	func test() {

	}
}

struct PaginationMetaData: PageMetaData {
	
	var page: Int
	var limit: Int
	var next: String
	
	static func parse(_ json: JSON) throws -> PaginationMetaData {
		return try PaginationMetaData(page: json["page"]^, limit: json["limit"]^, next: json["next"]^)
	}
	
	static func nextPageParams(currentIndex: Int, limit: Int, currentPageMetaData: PaginationMetaData?) -> [String : Any] {
		var params: [String: Any] = ["page": currentIndex + 1, "limit": limit]
		if let currentPageMetaData = currentPageMetaData {
			params["next"] = currentPageMetaData.next + "1"
		} else {
			params["next"] = "\(currentIndex + 1)"
		}
		return params
	}

//	static func nextRouter(currentIndex: Int, limit: Int, currentRouter: Router, currentPageMetaData: PaginationMetaData?) -> Router {
//		var params: [String: Any] = ["page": currentIndex + 1, "limit": limit]
//		if let currentPageMetaData = currentPageMetaData {
//			params["next"] = currentPageMetaData.next + "1"
//		} else {
//			params["next"] = "\(currentIndex + 1)"
//		}
//		return params
//	}

}

struct CursorPaginationMetaData: CursorPageMetaData {
	
	var next: String
	
	static func nextPageUrl(currentIndex: Int, limit: Int, currentPageMetaData: CursorPaginationMetaData?) -> URL? {
		if let currentPageMetaData = currentPageMetaData {
			return URL(string: "")
//			params["next"] = currentPageMetaData.next + "1"
		} else {
			return URL(string: "")
//			params["next"] = "\(currentIndex + 1)"
		}
	}
	
	static func parse(_ json: JSON) throws -> CursorPaginationMetaData {
		return try CursorPaginationMetaData(next: json["next"]^)
	}
	
}

public struct Number: Pageable {
	var value: Int
	
	public static func parse(_ json: JSON) throws -> Number {
		return try Number(
			value: json^
		)
	}
	
	public static func fetch(router: PageRouter, completion: @escaping (APIResult<PageResponse>) -> Void) {
		NonAuthAPIClient.shared.request(router, completion: completion)
	}
	

	public static func fetch(router: Router, completion: @escaping (APIResult<[Number]>) -> Void) {
		NonAuthAPIClient.shared.request(router) { (result: APIResult<ListResponse<Number>>) in
			switch result {
			case .success(let listResponse):
				completion(.success(listResponse.list))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
}
