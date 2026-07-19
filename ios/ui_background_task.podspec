#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ui_background_task.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ui_background_task'
  s.version          = '0.3.0'
  s.summary          = 'A Flutter iOS plugin for managing UI background tasks.'
  s.description      = <<-DESC
A Flutter iOS plugin that begins and ends UI background tasks so work can finish
after an app moves to the background.
                       DESC
  s.homepage         = 'https://github.com/Neelansh-ns/ui_background_task'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Neelansh Sethi' => 'sethineelansh@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'ui_background_task/Sources/ui_background_task/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
