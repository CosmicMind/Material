Pod::Spec.new do |s|
  s.name = 'Material'
  s.version = '2.2.2'
  s.license = 'BSD-3-Clause'
  s.summary = 'Material is an animation and graphics framework that is used to create beautiful applications.'
  s.homepage = 'http://materialswift.io'
  s.social_media_url = 'https://www.facebook.com/cosmicmindio'
  s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.io' }
  s.source = { :git => 'https://github.com/CosmicMind/Material.git', :tag => s.version }
  
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

  s.subspec 'Camera' do |camera|
    camera.source_files = 'Sources/iOS/Camera/*.swift'
    camera.dependency 'Material/Core'
  end

  s.subspec 'Photos' do |photos|
    photos.source_files = 'Sources/iOS/Photos/*.swift'
    photos.dependency 'Material/Core'
  end
end
