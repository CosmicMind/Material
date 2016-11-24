Pod::Spec.new do |s|
  s.name = 'Material'
  s.version = '2.3.17'
  s.license = 'BSD-3-Clause'
  s.summary = 'Material is an animation and graphics framework that is used to create beautiful applications.'
  s.homepage = 'http://materialswift.com'
  s.social_media_url = 'https://www.facebook.com/cosmicmindio'
  s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.com' }
  s.source = { :git => 'https://github.com/CosmicMind/Material.git', :tag => s.version }
  s.platform = :ios, '8.0'
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |s|
    s.ios.deployment_target = '8.0'
    s.ios.source_files = 'Sources/iOS/*.swift'
    s.osx.deployment_target = '10.9'
    s.osx.source_files = 'Sources/macOS/**/*.swift'
    s.requires_arc = true
    s.resource_bundles = {
        'io.cosmicmind.material.icons' => ['Sources/**/*.xcassets'],
        'io.cosmicmind.material.fonts' => ['Sources/**/*.ttf']
    }
  end

  s.subspec 'Capture' do |capture|
    capture.source_files = 'Sources/iOS/Capture/*.swift'
    capture.dependency 'Material/Core'
  end

  s.subspec 'Photos' do |photos|
    photos.source_files = 'Sources/iOS/Photos/*.swift'
    photos.dependency 'Material/Core'
  end
end
