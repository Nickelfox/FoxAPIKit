//
//  FileRequestManager.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation

public struct FileAPIRequest: FileRouter {
	
	public let fileUrl: URL
	
	public init(fileUrl: URL) {
		self.fileUrl = fileUrl
	}
	
}

open class FileRequestManager {
	
	public init() {}
	
	public func request(fileUrl: URL) -> FileRouter {
		return FileAPIRequest(fileUrl: fileUrl)
	}
	
}
