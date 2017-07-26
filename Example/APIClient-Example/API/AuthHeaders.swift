//
//  AuthHeaders.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient
import SwiftyJSON

public struct AuthHeaders: AuthHeadersProtocol {
	let accessToken: String
	
	public static func parse(_ json: JSON) throws -> AuthHeaders {
		return try AuthHeaders(
			accessToken: json[accessTokenKey]^
		)
	}
	
	public func toJSON() -> [String: String] {
		let res: [String: String] = [
			accessTokenKey: self.accessToken,
			]
		return res
	}
	
	public var isValid: Bool {
		return !self.accessToken.isEmpty
	}
	
}

extension AuthHeaders {
	public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
		var urlRequest = urlRequest
		urlRequest.setValue(self.accessToken, forHTTPHeaderField: "Access-Token")
		return urlRequest
	}
}

private let accessTokenKey = "access-token"
