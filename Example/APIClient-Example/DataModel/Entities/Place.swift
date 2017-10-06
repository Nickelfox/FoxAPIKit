//
//  Place.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 02/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import APIClient
import JSONParsing

public struct Place: Pageable {
	public var name: String
	
	public static func parse(_ json: JSON) throws -> Place {
		return try Place(name: json["name"]^)
	}
	
	public static func fetch(router: PaginationRouter, completion: @escaping (APIResult<PageResponse>) -> Void) {
		NonAuthAPIClient.shared.request(router, completion: completion)
	}
}
