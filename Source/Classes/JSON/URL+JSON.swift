//
//  URL+JSON.swift
//  Pods
//
//  Created by Ravindra Soni on 25/07/17.
//
//

extension URL: JSONParseTransformable {
	
	public typealias RawValue = String
	
	public static func transform(_ value: String) -> URL? {
		return URL(string: value)
	}
	
}
