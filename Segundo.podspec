Pod::Spec.new do |s|
  s.name             = "Segundo"
  s.version          = "0.1.3"
  s.summary          = "Get a leg up building iOS apps"
  s.homepage         = "https://github.com/MediaHound/Segundo"
  s.license          = 'Apache'
  s.author           = { "Dustin Bachrach" => "dustin@mediahound.com" }
  s.source           = { :git => "https://github.com/MediaHound/Segundo.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.private_header_files = "Pod/Classes/**/*+Internal.h"

  s.dependency 'AtSugar'
  s.dependency 'castaway'
  s.dependency 'KVOController'
  s.dependency 'PromiseKit/CorePromise'
  s.dependency 'DynamicInvoker'
end
