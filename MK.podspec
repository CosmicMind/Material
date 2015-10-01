Pod::Spec.new do |s|
  s.name = 'MK'
  s.version = '1.18.0'
  s.license = { :type => "AGPLv3+", :file => "LICENSE" }
  s.summary = 'A Material Design Framework In Swift'
  s.homepage = 'http://materialkit.io'
  s.social_media_url = 'https://www.facebook.com/graphkit'
  s.authors = { 'GraphKit, Inc.' => 'support@graphkit.io' }
  s.source = { :git => 'https://github.com/GraphKit/MaterialKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end

