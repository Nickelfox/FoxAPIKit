//
//  APIErrorType.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ACErrorDefaults {
	static let domain = "Error"
	static let message = "An unknown error has occured."
}

enum ACErrorCode: Int {
	case noInternet = 5555
	case mapping = 5556
	case unknown = 5557
	
	var code: Int {
		return self.rawValue
	}
}

enum ACError: AnyError {
	
	case unknown
	case noInternet
	case mapping(json: JSON, expectedType: String)
	
	var code: Int {
		switch self {
		case .mapping: return ACErrorCode.mapping.code
		case .noInternet: return ACErrorCode.noInternet.code
		case .unknown: return ACErrorCode.unknown.code
		}
	}

	var domain: String {
		return ACErrorDefaults.domain
	}
	
	var message: String {
		var message = ACErrorDefaults.message
		switch self {
		case .mapping (let json, let expectedType):
			message = "JSON value type mismatch for value \(json), expected type: \(expectedType)"
		case .noInternet:
			message = "No Internet Connection! Check your internet connection."
		case .unknown: break
		}
		return message
	}

}
