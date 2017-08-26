//
//  JSON.swift
//  JSONParsing
//
//  Created by Ravindra Soni on 25/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

public typealias JSON = SwiftyJSON.JSON

public extension JSON {
	
	public var optional: JSON? {
		if let _ = self.error {
			return nil
		} else {
			return self
		}
	}
	
	public func jsonAtKeyPath(keypath: String) -> JSON {
		return self.jsonAtKeyPaths(keypaths: keypath.components(separatedBy: "."))
	}
	
	public func jsonAtKeyPaths(keypaths: [String]) -> JSON {
		if keypaths.isEmpty {
			return self
		}
		var remainingKeypaths: [String] = []
		if keypaths.count > 1 {
			remainingKeypaths = Array(keypaths[1...keypaths.count-1])
		}
		return self[keypaths.first!].jsonAtKeyPaths(keypaths: remainingKeypaths)
	}
	
}
