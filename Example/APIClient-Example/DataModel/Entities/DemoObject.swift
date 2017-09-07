//
//  DemoObject.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing

enum Test: Int, JSONParseRawRepresentable {
	typealias RawValue = Int
	case one = 1
	case two = 2
}

public struct DemoObject: CustomStringConvertible {
	let value: Test
	
	public var description: String {
		return "value: \(self.value)"
	}
}

extension DemoObject: JSONParseable {
	public static func parse(_ json: JSON) throws -> DemoObject {
		return try DemoObject(
			value: json["id"]^
		)
	}
	
	func test() {

	}
}


