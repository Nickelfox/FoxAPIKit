//
//  Number.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing
import APIClient

public struct Number: Pageable {
	var value: Int
	
	public static func parse(_ json: JSON) throws -> Number {
		return try Number(
			value: json^
		)
	}
	
	public static func fetch(router: PaginationRouter, completion: @escaping (APIResult<PageResponse>) -> Void) {
		FoxAPIClient.shared.request(router, completion: completion)
	}
	
}
