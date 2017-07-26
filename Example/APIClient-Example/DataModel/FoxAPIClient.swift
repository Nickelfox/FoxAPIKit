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
	
	static let shared = FoxAPIClient()
	
	override init() {
		super.init()
		self.enableLogs = true
	}
	
	override func parseAuthenticationHeaders(_ response: HTTPURLResponse) {
		self.authHeaders = try? AuthHeaders.parse(JSON(response.allHeaderFields))
	}
	
}
