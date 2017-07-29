Pod::Spec.new do |s|
    s.name = 'Material'
    s.version = '2.8.1'
    s.license = 'BSD-3-Clause'
    s.summary = 'Material Design library used to create beautiful applications.'
    s.homepage = 'http://materialswift.com'
    s.social_media_url = 'https://www.facebook.com/cosmicmindcom'
    s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.com' }
    s.source = { :git => 'https://github.com/CosmicMind/Material.git', :tag => s.version }

    s.default_subspec = 'Core'
    s.platform = :ios, '8.0'

    s.subspec 'Core' do |s|
        s.ios.deployment_target = '8.0'
        s.ios.source_files = 'Sources/**/*.swift'
        s.requires_arc = true
        s.resource_bundles = {
            'com.cosmicmind.material.icons' => ['Sources/**/*.xcassets'],
            'com.cosmicmind.material.fonts' => ['Sources/**/*.ttf']
        }
    end
end
