//
//  MultipartFormData.swift
//  
//
//  Created by Vaibhav Parmar on 07/03/18.
//

import Foundation
import Alamofire

extension MultipartFormData {
    public func append(string: String, withName name: String) {
        if let data = string.data(using: .utf8) {
            self.append(data, withName: name)
        }
    }
    
    public func append(bool: Bool, withName name: String) {
        self.append(string: String(bool), withName: name)
    }
    
    public func append(int: Int, withName name: String) {
        self.append(string: String(int), withName: name)
    }
    
    public func append(int8: Int8, withName name: String) {
        self.append(string: String(int8), withName: name)
    }
    
    public func append(int16: Int16, withName name: String) {
        self.append(string: String(int16), withName: name)
    }
    
    public func append(int32: Int32, withName name: String) {
        self.append(string: String(int32), withName: name)
    }
    
    public func append(int64: Int64, withName name: String) {
        self.append(string: String(int64), withName: name)
    }
    
    public func append(double: Double, withName name: String) {
        self.append(string: String(double), withName: name)
    }
    
    public func append(float: Float, withName name: String) {
        self.append(string: String(float), withName: name)
    }
    
}

