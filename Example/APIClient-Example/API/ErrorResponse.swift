//
//  ErrorResponse.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient
import JSONParsing

private let errorKey = "error"

public struct ExampleError: AnyError {
	
	public var code: Int
	public var domain: String
	public var message: String

}

public struct ErrorResponse: ErrorResponseProtocol {
	public static func parse(_ json: JSON, code: Int) throws -> ErrorResponse {
		return try ErrorResponse(
			code: code,
			messages: [json["args"][errorKey]^]
		)
	}

	public var code: Int
	public let messages: [String]

	public var domain: String {
		return "Error"
	}
	
	public var message: String {
		return self.compiledErrorMessage
	}

	public var compiledErrorMessage: String {
		return self.messages.joined(separator: ",")
	}
}

