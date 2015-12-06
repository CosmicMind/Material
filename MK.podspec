Pod::Spec.new do |s|
  s.name = 'MK'
  s.version = '1.24.4'
  s.license = { :type => "AGPL-3.0", :file => "LICENSE" }
  s.summary = 'Beautiful Material Design in Swift.'
  s.homepage = 'http://materialkit.io'
  s.social_media_url = 'https://www.facebook.com/graphkit'
  s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.io' }
  s.source = { :git => 'https://github.com/CosmicMind/MaterialKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
end
