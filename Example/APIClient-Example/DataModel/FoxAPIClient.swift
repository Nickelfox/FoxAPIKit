//
//  FoxAPIClient.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient
import SwiftyJSON

class FoxAPIClient: APIClient<AuthHeaders, ErrorResponse> {
	
	override init() {
		super.init()
		self.enableLogs = true
	}
	
	override func authenticationHeaders(response: HTTPURLResponse) -> AuthHeaders? {
		return try? AuthHeaders.parse(JSON(response.allHeaderFields))
	}
	
	override func parseError(_ json: JSON, _ statusCode: Int) -> AnyError {
		if let errorResponse = try? ErrorResponse.parse(json, code: statusCode) {
			return errorResponse
		} else {
			return ExampleError(code: 0, domain: "Unknown", message: "Unknown Error")
		}
	}
		
}

class AuthAPIClient: FoxAPIClient {
	static let shared = AuthAPIClient()
	
	override init() {
		super.init()
	}
}

class NonAuthAPIClient: FoxAPIClient {
	static let shared = NonAuthAPIClient()
	
	override init() {
		super.init()
	}
}
