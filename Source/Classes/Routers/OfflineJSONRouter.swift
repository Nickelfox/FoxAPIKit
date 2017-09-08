//
//  OfflineJSONRouter.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public protocol OfflineJSONRouter: URLRouter {
	var jsonFileName: String { get }
}

extension OfflineJSONRouter {
	public var url: URL {
		if let path = Bundle.main.url(forResource: self.jsonFileName, withExtension: "json") {
			return path
		}
		preconditionFailure("JSON file with name: \(self.jsonFileName) doesn't exist")
	}
}
