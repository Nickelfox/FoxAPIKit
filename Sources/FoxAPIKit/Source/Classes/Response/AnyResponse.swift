//
//  AnyResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import JSONParsing

public struct AnyResponse: JSONParseable {
	public static func parse(_ json: JSON) throws -> AnyResponse {
		return AnyResponse()
	}
}
