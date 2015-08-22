Pod::Spec.new do |s|
  s.name = 'GK'
  s.version = '3.15.0'
  s.license = { :type => "AGPLv3+", :file => "LICENSE" }
  s.summary = 'A powerful iOS / OSX framework for data-driven design.'
  s.homepage = 'https://github.com/GraphKit/GraphKit'
  s.social_media_url = 'https://www.facebook.com/graphkit'
  s.authors = { 'GraphKit Inc.' => 'daniel@graphkit.io' }
  s.source = { :git => 'https://github.com/GraphKit/GraphKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end

