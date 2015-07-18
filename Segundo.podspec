Pod::Spec.new do |s|
  s.name             = "Segundo"
  s.version          = "0.1.0"
  s.summary          = "Get a leg up building iOS apps"
  s.homepage         = "https://github.com/MediaHound/Segundo"
  s.license          = 'Apache'
  s.author           = { "Dustin Bachrach" => "dustin@mediahound.com" }
  s.source           = { :git => "https://github.com/MediaHound/Segundo.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.private_header_files = "Pod/Classes/**/*+Internal.h"

  s.dependency 'AtSugar'
  s.dependency 'AtSugarMixin'
  s.dependency 'AgnosticLogger'
  s.dependency 'castaway'
  s.dependency 'ObjectiveMixin'
  s.dependency 'PromiseKit'
  s.dependency 'AFNetworking'
  s.dependency 'DynamicInvoker'
  s.dependency 'KVOController'
end
