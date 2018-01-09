//
//  URL+JSON.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

extension URL: JSONParseTransformable {
	
	public typealias RawValue = String
	
	public static func transform(_ value: String) -> URL? {
		return URL(string: value)
	}
	
}
