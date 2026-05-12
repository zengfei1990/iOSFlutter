source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '16.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'iOSFlutter.xcodeproj'

flutter_application_path = File.expand_path('flutter_learning_demo', __dir__)
flutter_ios_path = File.join(flutter_application_path, 'ios')
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

def install_add_to_app_flutter_pods(flutter_application_path)
  flutter_ios_path = File.join(flutter_application_path, 'ios')
  flutter_install_ios_engine_pod(flutter_ios_path)
  flutter_install_plugin_pods(flutter_ios_path, '.symlinks', 'ios')

  export_script_directory = File.join(flutter_application_path, 'ios', 'Flutter')
  relative = Pathname.new(File.expand_path(export_script_directory)).relative_path_from(Pathname.new(__dir__)).to_s
  flutter_export_environment_path = File.join('${SRCROOT}', relative, 'flutter_export_environment.sh')

  script_phase(
    name: 'Run Flutter Build flutter_learning_demo Script',
    script: "set -e\nset -u\nsource \"#{flutter_export_environment_path}\"\nexport VERBOSE_SCRIPT_LOGGING=1 && \"$FLUTTER_ROOT\"/packages/flutter_tools/bin/xcode_backend.sh build",
    execution_position: :before_compile
  )

  script_phase(
    name: 'Embed Flutter Build flutter_learning_demo Script',
    script: "set -e\nset -u\nsource \"#{flutter_export_environment_path}\"\nexport VERBOSE_SCRIPT_LOGGING=1 && \"$FLUTTER_ROOT\"/packages/flutter_tools/bin/xcode_backend.sh embed_and_thin",
    execution_position: :after_compile
  )
end

target 'iOSFlutter' do
  use_frameworks!
  install_add_to_app_flutter_pods(flutter_application_path)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end

  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |target|
      next unless target.name == 'iOSFlutter'

      target.build_configurations.each do |config|
        config.build_settings['FRAMEWORK_SEARCH_PATHS'] = '$(inherited) "${PODS_CONFIGURATION_BUILD_DIR}/Flutter"'
        config.build_settings['OTHER_LDFLAGS'] = '$(inherited) -framework Flutter'
      end
    end
  end
end
