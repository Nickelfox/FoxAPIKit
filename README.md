# FoxAPIKit
FoxAPIKit is wrapper around [Alamofire](https://github.com/Alamofire/Alamofire) networking library written in swift that provides a set of tools for working with APIs, including a router, APIClient, error handling, and API request and response handling. It is designed to simplify the process of making API requests and handling responses in Swift-based iOS applications.

## Installation
#### <i class="icon-file"></i>**CocoaPods**
[CocoaPods](https://cocoapods.org) is the dependency manager for Cocoa Libraries. You can install Cocoapods using the following command:

> `$ sudo gem install cocoapods`

If you wish to integrate `JSONParsing` in your project, then make following changes in your `Podfile`:

```  
platform :ios, '9.0'
use_frameworks!
target 'YourAppName' do
pod 'FoxAPIKit'
end
```

After saving `Podfile`. Run the following command:

pod install

#### <i class="icon-pencil"></I>**Install using Swift Package Manager**

The [Swift Package Manager](https://swift.org/package-manager) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding ForAPIKit as a dependency is as easy as adding it to the ```dependencies``` value of your ```Package.swift```.

```
dependencies: [
    .package(url: "https://github.com/Nickelfox/FoxAPIKit", .branch("master"))
]
```

#### <i class="icon-pencil"></I>**Manually**
If you don't want to use any dependency manager in your project, you can install this library manually too.
Just download and add the `Sources` folder to your project.

## Features

- Router: A flexible and extensible router that allows you to define your API endpoints as Swift enums, making it easy to manage your API routes in a type-safe way.
- APIClient: A powerful and customizable HTTP client that handles making API requests and handling responses, including handling authentication, headers, and query parameters.
- Error Handling: FoxAPIKit provides a set of error handling utilities called [AnyErrorKit](https://github.com/Nickelfox/AnyErrorKit) that allow you to define and handle custom API errors, making it easy to manage errors returned from API responses.
- APIRequest: A protocol that defines the structure of an API request, including the URL, HTTP method, headers, query parameters, and request body.
- APIResponse: A protocol that defines the structure of an API response, including the HTTP status code, headers, and response body.
- Parsing: [JSONParsing](https://github.com/Nickelfox/JSONParsing) is used to parse raw JSON and convert into `JSONParseable` or `Codable` type object.

## Usage

#### <i class="icon-file"></i>**Router**

`Router` is the core component of FoxAPIKit and allows you to define your API endpoints as Swift enums. `Router` protocol confirms `URLRequestConvertible` that contain all the elements require to create a URLRequest. Here's an example of how you can define a router:
```ruby
import FoxAPIKit

enum MyAPIRouter: Router {
    case getUsers
    case getUser(id: Int)
    case createUser(name: String, email: String)
    case updateUser(id: Int, name: String, email: String)
    case deleteUser(id: Int)
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser, .updateUser:
            return "/users"
        case .deleteUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        // Define custom headers for each API endpoint if needed
        return nil
    }
    
    var queryParameters: [String: Any]? {
        // Define query parameters for each API endpoint if needed
        return nil
    }
    
    var keypathToMap: String? { 
        // Define query keypathToMap for each API endpoint if needed
        return nil 
    }
}
```

#### <i class="icon-file"></i>**JSONParsing**
The `JSONParseable` or `Codable` protocol provided by FoxAPIKit allows you to easily create custom model objects in Swift from `JSON` data received from an API response. It simplifies the process of parsing and mapping JSON data to your model objects, making it efficient and convenient.
```ruby
// Confirm `JSONParseable` protocol
struct User: JSONParseable {
    
    var id: Int
    var name: String
    var weight: Double?
    var accounts: [String]
    
    static func parse(_ json: JSON) throws -> User {
        return try User(
            id: json["id"]^,
            name: json["name"]^!,
            weight: json["weight"]^?,
            accounts: json["accounts"]^^
        )
    }
}

// Confirm `Codable` protocol
struct User: Codable {
    
    var id: Int
    var name: String
    var weight: Double?
    var accounts: [String]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case weight
        case accounts
    }
}
```
