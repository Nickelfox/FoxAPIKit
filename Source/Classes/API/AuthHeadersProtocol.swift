//
//  AuthHeadersProtocol.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import Alamofire
import JSONParsing

public protocol AuthHeadersProtocol: JSONParseable, RequestAdapter {
	
	var isValid: Bool { get }
	
	func toJSON() -> [String: String]
	
}
