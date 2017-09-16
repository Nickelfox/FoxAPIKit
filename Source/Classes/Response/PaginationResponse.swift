//
//  PaginationResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//


import JSONParsing

public protocol PaginationInfoMapper {
	static var pageInfoKeypath: String? { get }
	static var objectsKeypath: String? { get }
}

public final class PaginationResponse<T: Pageable1, U: JSONParseable, V: PaginationInfoMapper> {
	public var objects: [T]
	public var pageInfo: U?
	
	public init(objects: [T], pageInfo: U?) throws {
		self.objects = objects
		self.pageInfo = pageInfo
	}
	
}

extension PaginationResponse: JSONParseable {
	
	public static func parse(_ json: JSON) throws -> PaginationResponse {
		var paginationJSON = json
		if let pageInfoKeypath = V.pageInfoKeypath {
			paginationJSON = json.jsonAtKeyPath(keypath: pageInfoKeypath)
		}
		var jsonList = json.arrayValue
		if let objectsKeypath = V.objectsKeypath {
			jsonList = json.jsonAtKeyPath(keypath: objectsKeypath).arrayValue
		}
		return try PaginationResponse(
			objects: jsonList.map(^),
			pageInfo: paginationJSON^?
		)
	}
}
