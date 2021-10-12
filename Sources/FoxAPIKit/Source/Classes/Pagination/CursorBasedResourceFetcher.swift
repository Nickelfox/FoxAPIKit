//
//  CursorBasedAdvancePaginator.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 15/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

public struct CursorBasedPageInfo<T> {
	var previousPageUrl: String?
	var nextPageUrl: String?
	var objects: [T]
}

public class CursorBasedAdvancePaginator<T>: AdvancePaginator<T> {

	public typealias CursorBasedAPICompletionHandler = (_ result: APIResult<CursorBasedPageInfo<T>>) -> Void

	var loadedPagesInfo = [Int: CursorBasedPageInfo<T>]()


	final internal override func resetAllInfo() {
		self.loadedPagesInfo.removeAll()
		super.resetAllInfo()
	}
	
	public override func fetchPage(pageNumber: Int, pageLimit: Int, completion: @escaping ExternalAPICompletionHandler) {
		
		let pageInfo = loadedPagesInfo[pageNumber]
		
		self.fetchPage(url: pageInfo?.nextPageUrl, pageLimit: self.pageLimit) { (result) in
			switch result{
			case .success(let pageInfo):
				self.loadedPagesInfo[pageNumber] = pageInfo
				completion(.success(pageInfo.objects))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	/**
	Fetches objects from the specified URL.

	* Must be overridden By subclass

	:param: `url`								the url from where to load objects. url = nil indicates loading the very first page

	:param: `pageLimit`							number of objects per page

	:param: `completion`						Completion Handler on success/failure

	*/

	public func fetchPage(url: String?, pageLimit: Int, completion: CursorBasedAPICompletionHandler){
		fatalError("This should be implemented in subclass")
	}
}

