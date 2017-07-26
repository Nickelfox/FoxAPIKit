//
//  APIRequestManager.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 20/07/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient

class APIRequestManager: RequestManager {
	
	static let shared: APIRequestManager = APIRequestManager()
	
	init() {
		super.init(baseUrl: URL.init(string: "https://httpbin.org")!)
		self.headers = ["Content-Type": "application/json"]
	}
}
