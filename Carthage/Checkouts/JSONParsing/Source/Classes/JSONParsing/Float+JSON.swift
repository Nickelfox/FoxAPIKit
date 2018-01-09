//
//  Float+JSON.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

extension Float: JSONParseablePrimitive {
	
	public static func transform(_ number: NSNumber) -> Float? {
		return number.floatValue
	}
	
	public static func transform(_ string: String) -> Float? {
		return Float(string)
	}
	
	public static func transform(_ json: JSON) -> Float {
		return json.floatValue
	}

}
