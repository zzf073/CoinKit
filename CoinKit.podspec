#
# Be sure to run `pod lib lint CoinKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoinKit'
  s.version          = '0.1.0'
  s.summary          = 'Create cryptocurrency apps easily'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Dmitry/CoinKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitry' => 'd.overchuk@titanium.im' }
  s.source           = { :git => 'https://github.com/Dmitry/CoinKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CoinKit/Core/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }
  
  s.framework = 'AVFoundation'
  s.vendored_frameworks = 'CoinKit/Frameworks/CoreBitcoin.framework', 'CoinKit/Frameworks/ethers.framework'
  
  s.dependency 'AFNetworking'
end