//
//  FileRouter.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public protocol FileRouter: Router {
	var fileUrl: URL { get }
}

extension FileRouter {
	public var keypathToMap: String? {
		return nil
	}
	
	public var timeoutInterval: TimeInterval? {
		return nil
	}
	
	public var encoding: URLEncoding? {
		return nil
	}
	
	public var method: HTTPMethod {
		return .get
	}
	
	public var path: String {
		return ""
	}
	
	public var params: [String: Any] {
		return [:]
	}
	
	public var baseUrl: URL {
		return self.fileUrl
	}
	
	public var headers: [String: String] {
		return [:]
	}
	
}

