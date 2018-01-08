#
# Be sure to run `pod lib lint AnyErrorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AnyErrorKit'
  s.version          = '0.1.1'
  s.summary          = 'A Generic and Basic error handling library for iOS by Fox Labs.'
  s.description      = <<-DESC
A Generic and Basic error handling library for iOS by Fox Labs. It contains utility methods for various classes in iOS.
						DESC

  s.homepage         = 'https://github.com/Nickelfox/AnyErrorKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ravindra Soni' => 'soni@nickelfox.com' }
  s.source           = { :git => 'https://github.com/Nickelfox/AnyErrorKit.git', :tag => s.version.to_s }

  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"
  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*'  
end
