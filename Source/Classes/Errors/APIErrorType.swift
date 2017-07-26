//
//  APIErrorType.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum APIErrorCode: Int {
	case noInternet = 5555
	case mapping = 5556
	case unknown = 5557
	
	var code: Int {
		return self.rawValue
	}
}

public enum APIErrorType: APIError {
	
	case unknown
	case noInternet
	case mapping(json: JSON, expectedType: String)
	
	public var code: Int {
		switch self {
		case .mapping: return APIErrorCode.mapping.code
		case .noInternet: return APIErrorCode.noInternet.code
		case .unknown: return APIErrorCode.unknown.code
		}
	}

	public var title: String {
		return APIErrorDefaults.title
	}
	
	public var message: String {
		var message = APIErrorDefaults.message
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
