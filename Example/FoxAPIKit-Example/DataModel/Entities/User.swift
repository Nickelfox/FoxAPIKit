//
//  User.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import JSONParsing
import FoxAPIKit

public struct User {
	let name: String
	
	static func fetchUser(completion: @escaping (APIResult<User>) -> Void) {
		let router = APIRouter.user
		FoxAPIClient.shared.request(router, completion: completion)
	}

	static func testUserError(completion: @escaping (APIResult<User>) -> Void) {
		let router = APIRouter.userError
		FoxAPIClient.shared.request(router, completion: completion)
	}
    
    static func fetchCodableUser(completion: @escaping (APIResult<User>) -> Void) {
        let router = APIRouter.user
        FoxAPIClient.shared.request(router, completion: completion)
    }
	
}

//extension User: JSONParseable {
//	public static func parse(_ json: JSON) throws -> User {
//		return try User(
//			name: json["name"]^
//		)
//	}
//}

extension User: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case name
    }
}
