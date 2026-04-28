# Flutter Add-to-App Guide

This workspace now contains two parts:

- `iOSFlutter/`: native iOS host app
- `flutter_learning_demo/`: Flutter learning demo code

## What has already been prepared

- The iOS app no longer depends on `Main.storyboard`
- `SceneDelegate` now builds the root navigation stack in code
- The home page has a button that opens a Flutter entry point
- If Flutter is not integrated yet, the app shows a placeholder page instead of crashing
- `AppDelegate` is ready to keep a shared `FlutterEngine` once the Flutter SDK is linked

## Recommended learning path

### Step 1: Install Flutter

Install Flutter locally and make sure `flutter doctor` passes the iOS checks.

### Step 2: Turn the demo folder into a real Flutter module

If you want the Flutter code to be embedded into the iOS host, the best shape is a Flutter module:

```bash
cd /Users/zf/Desktop/iOSFlutter
cd flutter_learning_demo
flutter create --template module .
```

The current learning code is already written to survive that command. Flutter will generate the missing module folders like `.ios/` and `.android/`, while keeping the existing `lib/` files in place.

### Step 3: Connect the module to iOS with CocoaPods

In the iOS host project directory:

```ruby
flutter_application_path = File.expand_path("../flutter_learning_demo", __dir__)
load File.join(flutter_application_path, ".ios", "Flutter", "podhelper.rb")

target "iOSFlutter" do
  install_all_flutter_pods(flutter_application_path)
end
```

Then run:

```bash
pod install
```

Open the generated `.xcworkspace` after that.

You can also use the helper script:

```bash
zsh /Users/zf/Desktop/iOSFlutter/setup_flutter_module.sh
```

### Step 4: Reuse the prepared host code

The current host app already contains:

- shared `FlutterEngine` startup in `AppDelegate`
- `FlutterEntryFactory.makeViewController()`
- a native-to-Flutter navigation entry

After the Flutter SDK is linked successfully, the placeholder page will automatically become a real `FlutterViewController`.

### Step 5: Handle routing

Right now the host sends:

```swift
flutterViewController.setInitialRoute("/learning")
```

So your Flutter module can read `/learning` as the first route and show the matching page.

## Why this structure is useful

- Native app remains the shell and owns the lifecycle
- Flutter can be added page by page instead of rewriting everything
- One shared Flutter module can later serve iOS and Android hosts together
- This is closer to real migration work than a pure Flutter greenfield app
