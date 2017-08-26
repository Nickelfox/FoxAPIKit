//
//  ErrorResponseProtocol.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import SwiftyJSON

public protocol ErrorResponseProtocol: AnyError {
	static func parse(_ json: JSON, code: Int) throws -> Self
}
