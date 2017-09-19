//
//  PaginationResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//


import JSONParsing

public protocol PaginationResponseProtocol: JSONParseable {
	associatedtype Element: Pageable
	associatedtype MetaData: PageMetaData
	
	var objects: [Element] {get}
	var pageMetaData: MetaData? {get}
}

public protocol PageMetaData: JSONParseable {}


public protocol PaginationInfoMapper {
	static var pageInfoKeypath: String? { get }
	static var objectsKeypath: String? { get }
}

public final class PaginationResponse<T: Pageable, U: PageMetaData, V: PaginationInfoMapper>: PaginationResponseProtocol {
	
	public typealias Element = T
	public typealias MetaData = U
	
	public var objects: [Element]
	public var pageMetaData: MetaData?
	
	public init(objects: [T], pageMetaData: U?) throws {
		self.objects = objects
		self.pageMetaData = pageMetaData
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
			pageMetaData: paginationJSON^?
		)
	}
}
