//
//  AdvancePaginator.swift
//  SwiftTests
//
//  Created by Ravindra Soni on 31/08/2015.
//  Copyright © 2015 Fueled Inc. All rights reserved.
//

import JSONParsing

public struct PageInfo<T> {
	public var objects: [T]
	public var hasMoreDataToLoad: Bool
	public var resourceFetcher: AdvancePaginator<T>
}

public struct AdvancePaginatorDefaults {
	public static var limit = 20
	public static var firstIndex = 1
}

open class AdvancePaginator<T> {

	public typealias AdvancePaginatorCompletionHandler = (_ result: APIResult<PageInfo<T>>) -> Void

	public typealias ExternalAPICompletionHandler = (_ result: APIResult<[T]>) -> Void

	final private (set) public var allObjects = [T]()

	final private (set) public var isLoading = false

	final private (set) public var currentPage: Int

	final private (set) public var pageLimit: Int

	final private (set) public var advanceLoadedObjects: [T]?
	
	public let initialIndex: Int
	private var nextLoadBlock: AdvancePaginatorCompletionHandler?

	// MARK: Initializer

	public init(initialIndex: Int = AdvancePaginatorDefaults.firstIndex,
				pageLimit: Int = AdvancePaginatorDefaults.limit) {
		self.initialIndex = initialIndex
		self.pageLimit = pageLimit
		self.currentPage = initialIndex
	}

	// MARK: Public Methods

	/**
	Start Fetching Products

	Calls `fetchPage(:pageLimit:completion)` with the first page and the page-limit specified during initialization.

	On successful completion clears the current set of Objects, if any and replaces them with the newly fetched results.

	Then performs the fetch for the next page silently

	:param: `completionHandler`	called when the fetch is completed

	*/


	final public func refresh(completion: @escaping AdvancePaginatorCompletionHandler) {
		if(self.isLoading) {
			completion(.failure(PaginatorError.alreadyLoading))
			return
		}

		self.resetAllInfo()

		self.loadNextPages { (result) in
			switch result{
			case .success(let fetcherInfo):
				self.allObjects.removeAll()
				self.allObjects += fetcherInfo.objects
				if fetcherInfo.hasMoreDataToLoad {
					self.fetchNextPage(userInitiated: false, completion: {_ in})
				}
				completion(.success(fetcherInfo))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	/**
	Fetch Next Page

	Calls `fetchPage(:pageLimit:completion)` with the next page to be fetched and cached and the page-limit specified during initialization.

	On successful completion clears the current set of Objects, if any and replaces them with the newly fetched results.

	Then performs the fetch for the next page silently

	:param: `completionHandler`	called when the fetch is completed

	*/
	final public func loadNext(completion: @escaping AdvancePaginatorCompletionHandler) {
		fetchNextPage(userInitiated: true, completion: completion)
	}

	/**
	Fetches the Next Page from the specified URL.

	* Must be overridden By subclass

	:param: `pageNumber`								the page number of the fetching page

	:param: `pageLimit`									number of objects per page

	:param: `completionHandler`					Completion Handler on success/failure

	*/

	public func fetchPage(pageNumber: Int, pageLimit: Int, completion: @escaping ExternalAPICompletionHandler) {
		assertionFailure("This method needs to be implemented in a subclass")
	}


	// MARK: Private Methods
	internal func resetAllInfo() {
		self.currentPage = self.initialIndex
		self.advanceLoadedObjects = nil
	}

	final private func fetchNextPage(userInitiated: Bool = false, completion: @escaping AdvancePaginatorCompletionHandler) {
		print("xxxx - \(NSDate()) - AdvancePaginator: Fetching Next Page, UserInitiated? \(userInitiated)")
		if userInitiated {
			/* If user initiated, check if there are advance loaded objects.
			If exists then send loaded objects back, and load next batch.
			*/
			if let advanceLoadedObjects = advanceLoadedObjects {
				allObjects += advanceLoadedObjects
				self.advanceLoadedObjects = nil
				print("xxxx - \(NSDate()) - AdvancePaginator: Returning Advanced Loaded Objects")
				let fetcherInfo = PageInfo(
					objects: advanceLoadedObjects,
					hasMoreDataToLoad: advanceLoadedObjects.count >= self.pageLimit,
					resourceFetcher: self
				)
				completion(.success(fetcherInfo))
			}
			else {
				//Setting Next Block
				self.nextLoadBlock = completion

				//Already Loading. So return. you'll get data in nextLoadBlock
				if self.isLoading {
					print("xxxx - \(NSDate()) - AdvancePaginator: Already Loading With Completion")
					return
				} else {
					print("xxxx - \(NSDate()) - AdvancePaginator: Loading Objects in Advance")
				}
			}
		}

		self.loadNextPages { (result) in
			switch result {
			case .success(let fetcherInfo):
				if let nextLoadBlock = self.nextLoadBlock {
					self.allObjects += fetcherInfo.objects
					nextLoadBlock(.success(fetcherInfo))
					self.nextLoadBlock = nil
					
					if fetcherInfo.hasMoreDataToLoad {
						self.fetchNextPage(userInitiated: false, completion: { _ in})
					}
				} else {
					self.advanceLoadedObjects = fetcherInfo.objects
				}
			case .failure(let error):
				self.nextLoadBlock?(.failure(error))
				self.nextLoadBlock = nil
			}
		}
	}

	final private func loadNextPages(completion:@escaping AdvancePaginatorCompletionHandler) {
		isLoading = true

		print("xxxx - \(NSDate()) - AdvancePaginator:  Fetching Page \(self.currentPage)")

		self.fetchPage(pageNumber: self.currentPage, pageLimit: self.pageLimit) { result in
			switch result {
			case .success(let objects):
				self.currentPage += 1
				let info = PageInfo(
					objects: objects,
					hasMoreDataToLoad: objects.count >= self.pageLimit,
					resourceFetcher: self
				)
				completion(.success(info))
			case .failure(let error):
				completion(.failure(error))
			}
		}
		
	}
}
