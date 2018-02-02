#
# Be sure to run `pod lib lint BitcoinKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BitcoinKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BitcoinKit.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Dmitry/BitcoinKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitry' => 'd.overchuk@titanium.im' }
  s.source           = { :git => 'https://github.com/Dmitry/BitcoinKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'BitcoinKit/Core/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }
  
  s.dependency 'Arcane'
  s.framework = 'AVFoundation'
  s.vendored_frameworks = 'BitcoinKit/Frameworks/CoreBitcoin.framework'
end
