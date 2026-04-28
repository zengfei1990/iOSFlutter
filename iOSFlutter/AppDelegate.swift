import UIKit
#if canImport(Flutter)
import Flutter
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    #if canImport(Flutter)
    lazy var flutterEngine: FlutterEngine = {
        let engine = FlutterEngine(name: "shared_flutter_engine")
        engine.run()
        return engine
    }()
    #endif


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if canImport(Flutter)
        _ = flutterEngine
        #endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
