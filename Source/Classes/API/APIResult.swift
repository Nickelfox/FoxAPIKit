//
//  APIResult.swift
//  APIClient
//
//  Created by Ravindra Soni on 20/07/17.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public enum APIResult<Value> {
	case success(Value)
	case failure(AnyError)
	
	public var isSuccess: Bool {
		switch self {
		case .success:
			return true
		case .failure:
			return false
		}
	}
	
	/// Returns `true` if the result is a failure, `false` otherwise.
	public var isFailure: Bool {
		return !isSuccess
	}
	
	/// Returns the associated value if the result is a success, `nil` otherwise.
	public var value: Value? {
		switch self {
		case .success(let value):
			return value
		case .failure:
			return nil
		}
	}
	
	/// Returns the associated error value if the result is a failure, `nil` otherwise.
	public var error: AnyError? {
		switch self {
		case .success:
			return nil
		case .failure(let error):
			return error
		}
	}

}
