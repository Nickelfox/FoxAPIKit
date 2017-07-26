//
//  DataModel.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/01/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import APIClient

typealias APICompletion<T> = (APIResult<T>) -> Void

class DataModel {

	static func demo(completion: @escaping APICompletion<DemoObject>) {
		let params = ["values": ["1", "2"]]
		let request = APIRequestManager.shared.get(
			path: "/anything",
			params: params,
			timeoutInterval: nil
		)
		FoxAPIClient.shared.request(router: request, completion: completion)
		
	}

}
