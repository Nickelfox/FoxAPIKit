//
//  CursorPaginatorViewController.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 20/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import PaginationUIManager
import APIClient

class CursorPaginatorViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	var paginationManager: PaginationUIManager?
	var paginator: Paginator<Place, FBPageMetaData>?
	
	var objects: [Place] {
		return self.paginator?.items ?? []
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.setupPaginationManager()
		self.paginator = Paginator(paginationRouterBlock: { (router, currentPageMetaData) -> PageRouter in
			if let url = currentPageMetaData?.nextUrl {
				return CursorPageRouter.fetchNumbersWithUrl(url)
			} else {
				return CursorPageRouter.fetchNumbers
			}
//			return APICursorPageRouter.fetchNumbers(currentPageMetaData?.next, page: (currentPageMetaData?.page ?? 0) + 1)
		})
//		self.paginator = Paginator(router: APIPageRouter.fetchNumbers, limit: 20)
		//		self.paginator = IndexPaginator(router: APIRouter.fetchNumbers, initialIndex: 0, limit: 20, paginatorType: .pageBased)
		self.paginationManager?.load {
			
		}
	}
	
	func setupPaginationManager() {
		self.paginationManager = PaginationUIManager(scrollView: self.tableView, pullToRefreshType: .basic)
		self.paginationManager?.delegate = self
	}
	
}

extension CursorPaginatorViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.objects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = String(self.objects[indexPath.row].name)
		return cell
	}
}

extension CursorPaginatorViewController: PaginationUIManagerDelegate {
	
	func refreshAll(completion: @escaping (Bool) -> Void) {
		self.paginator?.refresh(completion: { [weak self] result in
			switch result {
			case .success(let items):
				self?.tableView.reloadData()
				completion(items.count >= 20)
			case .failure(let error):
				print("refresh Error: \(error.message)")
				completion(true)
			}
		})
	}
	
	func loadMore(completion: @escaping (Bool) -> Void) {
		self.paginator?.loadNext(completion: { [weak self] result in
			switch result {
			case .success(let items):
				self?.tableView.reloadData()
				completion(items.count >= 20)
			case .failure(let error):
				print("refresh Error: \(error.message)")
				completion(true)
			}
		})
		
	}
	
}
