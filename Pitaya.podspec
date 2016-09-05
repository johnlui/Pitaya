#
# Be sure to run `pod lib lint BMPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Pitaya"
  s.version          = "1.0.0"
  s.summary          = "A Swift HTTP / HTTPS networking library just incidentally execute on machines"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Pitaya is a Swift HTTP / HTTPS networking library for people. Inspired by Alamofire and JustHTTP.
                        DESC

  s.homepage         = "https://github.com/johnlui/Pitaya"

  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "johnlui" => "wenhanlv@gmail.com" }
  s.source           = { :git => "https://github.com/johnlui/Pitaya.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/balishengmuyuan'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pitaya/**/*','Source/**/*'

  s.public_header_files = 'Pitaya/*.h'
  #s.frameworks = 'UIKit', 'AVFoundation'
  #s.dependency 'SnapKit'
  # s.dependency 'NVActivityIndicatorView', '~> 2.6'
end
