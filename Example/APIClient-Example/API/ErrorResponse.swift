//
//  ErrorResponse.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient
import SwiftyJSON

private let errorKey = "error"

public struct ExampleError: APIError {
	
	public var code: Int
	public var title: String
	public var message: String

	
}

public struct ErrorResponse: ErrorResponseProtocol {
	public static func parse(_ json: JSON, code: Int) throws -> ErrorResponse {
		let unknownError = ExampleError(code: code, title: "Error", message: "Error Response can't be mapped.")
		if json[errorKey] != JSON.null {
			return try ErrorResponse(
				code: code,
				messages: json[errorKey].arrayValue.map(^)
			)
		} else {
			throw unknownError
		}
	}

	public var code: Int
	public let messages: [String]

	public var title: String {
		return "Error"
	}
	
	public var message: String {
		return self.compiledErrorMessage
	}

	public var compiledErrorMessage: String {
		return self.messages.joined(separator: ",")
	}
}

