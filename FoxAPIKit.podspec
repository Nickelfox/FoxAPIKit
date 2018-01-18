#
# Be sure to run `pod lib lint FoxAPIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FoxAPIKit'
  s.version          = '0.1.4'
  s.summary          = 'A wrapper over Alamofire for handling APIs for iOS by Fox Labs.'
  s.description      = <<-DESC
A wrapper over Alamofire for handling APIs for iOS by Fox Labs. It contains utility methods for various classes in iOS.
						DESC
  s.homepage         = 'https://github.com/Nickelfox/FoxAPIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ravindra Soni' => 'soni@nickelfox.com' }
  s.source           = { :git => 'https://github.com/Nickelfox/FoxAPIKit.git', :tag => s.version.to_s }

  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*'
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftyJSON', '~> 3.1'
  s.dependency 'JSONParsing', '~> 0.1.3'
  s.dependency 'AnyErrorKit', '~> 0.1.1'
end
