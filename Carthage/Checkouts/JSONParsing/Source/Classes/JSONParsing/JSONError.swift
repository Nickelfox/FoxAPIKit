//
//  JSONError.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON
import AnyErrorKit

public enum JSONError: AnyError {
	
	case typeMismatch(json: JSON, expectedType: String)
	case invalidTransform(json: JSON, fromType: String, toType: String)
	
	public var code: Int {
		return 3333
	}

	public var domain: String {
		return "JSON Error"
	}

	public var message: String {
		switch self {
		case .typeMismatch(let json, let expectedType):
			return "json error: value type mismatch for value \(json), expected type: \(expectedType)"
		case .invalidTransform(let json, let fromType, let toType):
			return "json error: can't transform value: \(json), from: \(fromType) to: \(toType)"
		}
	}

}
