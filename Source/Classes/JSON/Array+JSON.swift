//
//  Array+JSON.swift
//  Pods
//
//  Created by Ravindra Soni on 25/07/17.
//
//

import SwiftyJSON

postfix operator ^^
public postfix func ^^ <T: JSONParseable> (json: JSON) throws -> Array<T> {
	return try Array<T>.parse(json)
}


extension Array where Element: JSONParseable {
	
	public static func parse(_ json: JSON) throws -> Array<Element> {
		return try json.arrayValue.map { try Element.parse($0) }
	}
	
	
}
