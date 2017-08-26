//
//  ListResponse.swift
//  APIClient
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import JSONParsing

public final class ListResponse<T: JSONParseable> {
    public var list: [T] = []
}

extension ListResponse: JSONParseable {
    
    public static func parse(_ json: JSON) throws -> ListResponse {
        let jsonList = json.arrayValue
        
        let listResponse = ListResponse()
        for json in jsonList {
            do {
                let object = try T.parse(json)
                listResponse.list.append(object)
            } catch {
                throw error
            }
        }
        return listResponse
    }	
}
