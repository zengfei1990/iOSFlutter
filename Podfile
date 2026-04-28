platform :ios, '16.0'

project 'iOSFlutter.xcodeproj'

flutter_application_path = File.expand_path('flutter_learning_demo', __dir__)
flutter_podhelper_path = File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

unless File.exist?(flutter_podhelper_path)
  raise <<~MESSAGE
    Flutter module is not ready yet.

    Expected:
      #{flutter_podhelper_path}

    Next step:
      1. Install Flutter SDK
      2. Run `flutter create --template module .` inside /Users/zf/Desktop/iOSFlutter/flutter_learning_demo
      3. Run `pod install` again from /Users/zf/Desktop/iOSFlutter
  MESSAGE
end

load flutter_podhelper_path

target 'iOSFlutter' do
  use_frameworks!
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
