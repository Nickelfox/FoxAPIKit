//
//  APIError.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

struct APIErrorDefaults {
	static let title = "Error"
	static let message = "An unknown error has occured."
}

public protocol APIError: Error {
	var code: Int { get }
	var title: String { get }
	var message: String { get }
}


extension NSError: APIError {

	public var title: String {
		return self.domain
	}

	public var message: String {
		return (self.userInfo[NSLocalizedDescriptionKey] as? String) ?? APIErrorDefaults.message
	}

}

extension JSONError: APIError {
	
	public var title: String {
		return self.domain
	}
	
	public var message: String {
		return self.description
	}
	
}
