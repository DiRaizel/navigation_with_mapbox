#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint navigation_with_mapbox.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'navigation_with_mapbox'
  s.version          = '0.0.6'
  s.summary          = 'Add Turn By Turn Navigation to Your Flutter Application Using MapBox. '
  s.description      = <<-DESC
  Add Turn By Turn Navigation to Your Flutter Application Using MapBox. 
                       DESC
  s.homepage         = 'https://github.com/DiRaizel/navigation_with_mapbox'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Raizel' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.dependency 'MapboxCoreNavigation', '~> 2.7'
  s.dependency 'MapboxNavigation', '~> 2.7'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
