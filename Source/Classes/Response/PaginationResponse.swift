//
//  PaginationResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//


import JSONParsing

//public protocol PaginationInfoMapper {
//	static var pageInfoKeypath: String { get }
//	static var objectsKeypath: String { get }
//}
//
//public protocol PageInfo: JSONParseable {
//	var index: Int { get }
//	var limit: Int { get }
//	var count: Int { get }
//	var totalCount: Int { get }
//}
//
//public final class PaginationResponse<T: JSONParseable, U: PageInfo, V: PaginationInfoMapper> {
//	public var objects: [T]
//	public var pageInfo: U
//	
//	public init(objects: [T], pageInfo: U) throws {
//		self.objects = objects
//		self.pageInfo = pageInfo
//	}
//	
//}
//
//extension PaginationResponse: JSONParseable {
//	
//	public static func parse(_ json: JSON) throws -> PaginationResponse {
//		let paginationJSON = json.jsonAtKeyPath(keypath: V.pageInfoKeypath)
//		let jsonList = json.jsonAtKeyPath(keypath: V.objectsKeypath).arrayValue
//		return try PaginationResponse(
//			objects: jsonList.map(^),
//			pageInfo: paginationJSON^
//		)
//	}
//}
