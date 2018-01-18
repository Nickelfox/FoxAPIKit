//
//  JSONParseablePrimitive.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

public protocol JSONParseablePrimitive: JSONParseable {
	static func transform(_ number: NSNumber) -> Self?
	static func transform(_ string: String) -> Self?
	static func transform(_ json: JSON) -> Self
}

public extension JSONParseablePrimitive {
	
	public static func parse(_ json: JSON) throws -> Self {
		if let error = json.error {
			throw error
		}
		guard let value = Self.optionalValue(json) else {
			throw JSONError.typeMismatch(json: json, expectedType: String(describing: Self.self))
		}
		return value
	}
	
	fileprivate static func forceValue(_ json: JSON) -> Self {
		return Self.transform(json)
	}
	
	private static func optionalValue(_ json: JSON) -> Self? {
		if json.type == .number {
			return Self.transform(json.object as! NSNumber)
		} else if json.type == .string {
			return Self.transform(json.object as! String)
		} else if json.type == .bool {
			return Self.transform(NSNumber(value: json.object as! Bool))
		} else {
			return nil
		}
	}
	
}

// Keeping this operator explicitely for Primitive Transofrmable types
postfix operator ^!
public postfix func ^! <T: JSONParseablePrimitive> (json: JSON) -> T! {
	return T.forceValue(json)
}

