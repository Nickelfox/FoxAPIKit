//
//  PaginatorError.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 07/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

public enum PaginatorError: AnyError {
	public var domain: String {
		return "AdvancePaginatorError"
	}

	public var code: Int { return 0 }
	
	public var message: String {
		switch self {
		case .pageDoesNotExist:
			return "Page does not exist"
		case .alreadyLoading:
			return "AdvancePaginator is already loading this page"
		case .unknown:
			return "An unknown error occured."
		case .other:
			return "An unknown error occured."
		}
	}
	
	case pageDoesNotExist, alreadyLoading, unknown, other
}
