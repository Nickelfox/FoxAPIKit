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
//		let params = ["id": 1]
//		let request = APIRequestManager.shared.get(
//			path: "/anything",
//			params: params,
//			keypathToMap: "args",
//			timeoutInterval: nil
//		)
		
//		let offlineJSONRequestManager = OfflineJSONRequestManager()
//		let request = offlineJSONRequestManager.request(jsonFileName: "Test")

		let url = URL(string: "http://beta.json-generator.com/api/json/get/4kWfQV5KQ")!
		let fileRequestManager = FileRequestManager()
		let request = fileRequestManager.request(fileUrl: url)
		
		FoxAPIClient.shared.request(request, completion: completion)
	}

}
