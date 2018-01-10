//
//  JSONParseTransformable.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

// For Values that can be transformed
public protocol JSONParseTransformable: JSONParseable {
	
	associatedtype RawValue: JSONParseable
	
	static func transform(_ value: RawValue) -> Self?
	
}

extension JSONParseTransformable {

	public static func parse(_ json: JSON) throws -> Self {
		do {
			let rawValue = try RawValue.parse(json)
			if let transformedValue = Self.transform(rawValue) {
				return transformedValue
			} else {
				throw JSONError.invalidTransform(
					json: json,
					fromType: String(describing: RawValue.self),
					toType: String(describing: Self.self))
			}
		} catch {
			throw error
		}
	}

}
