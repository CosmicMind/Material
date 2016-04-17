Pod::Spec.new do |s|
  s.name = 'Material'
  s.version = '1.39.12'
  s.license = 'BSD'
  s.summary = 'An animation and graphics framework for Material Design in Swift.'
  s.homepage = 'http://cosmicmind.io'
  s.social_media_url = 'https://www.facebook.com/graphkit'
  s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.io' }
  s.source = { :git => 'https://github.com/CosmicMind/Material.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.ios.source_files = 'Sources/iOS/**/*.swift'
  s.osx.deployment_target = '10.9'
  s.osx.source_files = 'Sources/OSX/**/*.swift'
  s.requires_arc = true
  s.resource_bundles = {
      'io.cosmicmind.material.fonts' => ['Sources/**/*.ttf'],
      'io.cosmicmind.material.icons' => ['Sources/Assets.xcassets/**/*.png']
  }
end
