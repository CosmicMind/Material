Pod::Spec.new do |s|
  s.name = 'Material'
  s.version = '2.6.3'
  s.license = 'BSD-3-Clause'
  s.summary = 'An animation and graphics framework for Material Design in Swift.'
  s.homepage = 'http://materialswift.com'
  s.social_media_url = 'https://www.facebook.com/cosmicmindcom'
  s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.com' }
  s.source = { :git => 'https://github.com/CosmicMind/Material.git', :tag => s.version }

  s.default_subspec = 'Core'
  s.platform = :ios, '8.0'

  s.subspec 'Core' do |s|
    s.ios.deployment_target = '8.0'
    s.ios.source_files = 'Sources/iOS/*.swift'
    s.requires_arc = true
    s.resource_bundles = {
        'com.cosmicmind.material.icons' => ['Sources/**/*.xcassets'],
        'com.cosmicmind.material.fonts' => ['Sources/**/*.ttf']
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

  s.subspec 'Reminders' do |reminders|
    reminders.source_files = 'Sources/iOS/Reminders/*.swift'
    reminders.dependency 'Material/Core'
 end

end
