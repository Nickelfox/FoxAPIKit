//
//  APIClientError.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate struct ErrorDefaults {
	static let domain = "Error"
	static let message = "An unknown error has occured."
}

fileprivate enum ErrorCode: Int {
	case noInternet = 5555
	case mapping = 5556
	case unknown = 5557
	
	var code: Int {
		return self.rawValue
	}
}

enum APIClientError: AnyError {
	
	case unknown
	case noInternet
	case mapping(json: JSON, expectedType: String)
	
	var code: Int {
		switch self {
		case .mapping: return ErrorCode.mapping.code
		case .noInternet: return ErrorCode.noInternet.code
		case .unknown: return ErrorCode.unknown.code
		}
	}

	var domain: String {
		return ErrorDefaults.domain
	}
	
	var message: String {
		var message = ErrorDefaults.message
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
