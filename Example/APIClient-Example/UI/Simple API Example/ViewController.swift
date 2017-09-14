//
//  ViewController.swift
//  APIClient-Example
//
//  Created by Ravindra Soni on 06/10/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var nameLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
//		User.fetchUser {  [weak self] result in
//			switch result {
//			case .success(let user):
//				self?.nameLabel.text = user.name
//			case .failure(let error):
//				print("error: \(String(describing: error.message))")
//			}
//		}
		
		User.testUserError {  [weak self] result in
			switch result {
			case .success(let user):
				self?.nameLabel.text = user.name
			case .failure(let error):
				self?.nameLabel.text = error.message
			}
			
		}
	
	}
	
}
