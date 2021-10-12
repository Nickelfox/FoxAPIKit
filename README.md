# FLAPIClient
API Client

## Installation
#### <i class="icon-file"></i>**CocoaPods**
[CocoaPods](https://cocoapods.org) is the dependency manager for Cocoa Libraries. You can install Cocoapods using the following command:

> `$ sudo gem install cocoapods`

If you wish to integrate `JSONParsing` in your project, then make following changes in your `Podfile`:

```  
platform :ios, '9.0'
use_frameworks!
target 'YourAppName' do
pod 'FoxAPIKit', :git => 'https://github.com/Nickelfox/FoxAPIKit.git', :branch => 'develop'
end
```

After saving `Podfile`. Run the following command:

pod install

#### <i class="icon-pencil"></I>**Install using Swift Package Manager**

The [Swift Package Manager](https://swift.org/package-manager) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding ForAPIKit as a dependency is as easy as adding it to the ```dependencies``` value of your ```Package.swift```.

```
dependencies: [
    .package(url: "https://github.com/Nickelfox/FoxAPIKit", .branch("develop"))
]
```

#### <i class="icon-pencil"></I>**Manually**
If you don't want to use any dependency manager in your project, you can install this library manually too.
Just download and add the `Sources` folder to your project.
