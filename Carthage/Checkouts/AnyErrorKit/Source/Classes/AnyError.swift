//
//  AnyError.swift
//  Pods
//
//  Created by Ravindra Soni on 26/08/17.
//
//

import Foundation

struct AnyErrorDefaults {
	static let domain = "Error"
	static let message = "An unknown error has occured."
}

public protocol AnyError: Error {
	var code: Int { get }
	var domain: String { get }
	var message: String { get }
}


extension NSError: AnyError {
	
	public var message: String {
		return (self.userInfo[NSLocalizedDescriptionKey] as? String) ?? AnyErrorDefaults.message
	}
	
}
