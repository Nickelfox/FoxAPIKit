//
//  PaginationResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 14/09/17.
//	Copyright © 2016 Nickelfox. All rights reserved.
//


import JSONParsing

public protocol PaginationResponseProtocol {
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

public struct PageResponse: JSONParseable {
	let json: JSON
	
	public static func parse(_ json: JSON) throws -> PageResponse {
		return PageResponse(json: json)
	}
}



public final class PaginationResponse<T: Pageable, U: PageMetaData>: PaginationResponseProtocol {
	
	public typealias Element = T
	public typealias MetaData = U
	
	public var objects: [Element]
	public var pageMetaData: MetaData?
	
	public init(objects: [T], pageMetaData: U?) throws {
		self.objects = objects
		self.pageMetaData = pageMetaData
	}
	
}

extension PaginationResponse {
	
	public static func parse(_ json: JSON, pageInfoKeypath: String?, objectsKeypath: String?) throws -> PaginationResponse {
		var paginationJSON = json
		if let pageInfoKeypath = pageInfoKeypath {
			paginationJSON = json.jsonAtKeyPath(keypath: pageInfoKeypath)
		}
		var jsonList = json.arrayValue
		if let objectsKeypath = objectsKeypath {
			jsonList = json.jsonAtKeyPath(keypath: objectsKeypath).arrayValue
		}
		var objects: [T] = []
		for jsonObject in jsonList {
			do {
				let object = try T.parse(jsonObject)
				objects.append(object)
				
			} catch {
				throw error
			}
		}
		return try PaginationResponse(
			objects: objects,
			pageMetaData: paginationJSON^?
		)
	}
}
