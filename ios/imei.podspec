Pod::Spec.new do |s|
  s.name             = 'imei'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to get device IMEI.'
  s.description      = <<-DESC
A Flutter plugin to get device IMEI number on Android and iOS devices.
                       DESC
  s.homepage         = 'https://github.com/BahromjonPolat/flutter-imei-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Bahromjon Polat' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
