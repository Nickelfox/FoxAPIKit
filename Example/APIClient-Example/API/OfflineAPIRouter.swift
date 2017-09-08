//
//  OfflineAPIRouter.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 08/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import APIClient
enum OfflineAPIRouter: OfflineJSONRouter {
	
	case demo
	case demoError
	
	var jsonFileName: String {
		switch self {
		case .demo:
			return "Test"
		case .demoError:
			return "TestError"
		}
	}
}
