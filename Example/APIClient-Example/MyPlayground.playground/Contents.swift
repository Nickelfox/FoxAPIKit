//: Playground - noun: a place where people can play

import UIKit
import APIClient
import SwiftyJSON

enum Test: String, JSONParseRawRepresentable {
	typealias RawValue = String
	case one = "one"
	case two = "two"
	case three
}
//let jsonData = "{\"activities\": {\"running\": {\"distance\": false}}}"
//let jsonData = "{\"url\": \"hello\"}"
//let jsonData = "{\"url\": null}"
let jsonData = "{\"data\": [\"one\",\"two\"]}"
let data = jsonData.data(using: .utf8)!
let json = JSON(data: data)
struct Object: JSONParseable {
	
	let values: [Test]
	
	static func parse(_ json: JSON) throws -> Object {
//		return try Object(values: Array<Int>.parse(json["data"]))
		return try Object(values: json["data"]^^)
//		return try Object(status: json["activities"]["running"]["distance"]^)
//		activities.running.distance
	}
	
}


do {
	let object = try Object.parse(json)
	print(object.values)
} catch {
	print(error)
}
