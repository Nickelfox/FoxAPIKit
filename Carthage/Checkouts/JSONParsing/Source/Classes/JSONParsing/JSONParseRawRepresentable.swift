//
//  JSONParseRawRepresentable.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON


// For Raw Representables like enums
public protocol JSONParseRawRepresentable: RawRepresentable, JSONParseable {
	associatedtype RawValue: JSONParseable
}

public extension JSONParseRawRepresentable {
	
	public static func parse(_ json: JSON) throws -> Self {
		if let transformedValue = try Self(rawValue: json^) {
			return transformedValue
		} else {
			throw JSONError.invalidTransform(
				json: json,
				fromType: String(describing: RawValue.self),
				toType: String(describing: Self.self))
		}
	}
	
}
