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
