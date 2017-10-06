//
//  OfflineJSONRequestManager.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation


public struct OfflineJSONAPIRequest: OfflineJSONRouter {
	
	public let jsonFileName: String
	
	public init(jsonFileName: String) {
		self.jsonFileName = jsonFileName
	}
	
}

open class OfflineJSONRequestManager {
	
	public init() {}

	public func request(jsonFileName: String) -> OfflineJSONRouter {
		return OfflineJSONAPIRequest(jsonFileName: jsonFileName)
	}
	
}
