source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '16.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'iOSFlutter.xcodeproj'

flutter_ios_path = File.expand_path('flutter_learning_demo/ios', __dir__)
generated_xcode_build_settings_path = File.join(flutter_ios_path, 'Flutter', 'Generated.xcconfig')

unless File.exist?(generated_xcode_build_settings_path)
  raise <<~MESSAGE
    Flutter module is not ready yet.

    Expected:
      #{generated_xcode_build_settings_path}

    Next step:
      1. Run `flutter pub get` inside /Users/zf/Desktop/iOSFlutter/flutter_learning_demo
      2. If `ios/` is missing, run `flutter create --template module .`
      3. Run `pod install` again from /Users/zf/Desktop/iOSFlutter
  MESSAGE
end

def flutter_root(generated_xcode_build_settings_path)
  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end

  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}"
end

require File.expand_path(
  File.join('packages', 'flutter_tools', 'bin', 'podhelper'),
  flutter_root(generated_xcode_build_settings_path)
)

flutter_ios_podfile_setup

target 'iOSFlutter' do
  use_frameworks!
  flutter_install_all_ios_pods(flutter_ios_path)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
