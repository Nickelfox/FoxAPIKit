//
//  String+JSON.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

extension String: JSONParseablePrimitive {
	
	public static func transform(_ number: NSNumber) -> String? {
		return number.stringValue
	}
	
	public static func transform(_ string: String) -> String? {
		return string
	}
	
	public static func transform(_ json: JSON) -> String {
		return json.stringValue
	}

}
