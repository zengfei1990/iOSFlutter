import UIKit
#if canImport(Flutter)
import Flutter
#endif

enum FlutterBridgeCoordinator {
    static let channelName = "com.huami.ios_flutter/demo"
    static let formResultDidUpdateNotification = Notification.Name("FlutterFormResultDidUpdate")

    private static weak var flutterViewController: UIViewController?
    private static var hostSyncCount = 0
    private static var lastFormResultSummary = "No Flutter form submitted yet."

    #if canImport(Flutter)
    private static var channel: FlutterMethodChannel? {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return nil
        }

        return FlutterMethodChannel(
            name: channelName,
            binaryMessenger: appDelegate.flutterEngine.binaryMessenger
        )
    }
    #endif

    static func bindFlutterViewController(_ viewController: UIViewController) {
        flutterViewController = viewController
        configureMethodChannel()
        pushHostStateToFlutter()
    }

    static func incrementHostSyncCount() {
        hostSyncCount += 1
        pushHostStateToFlutter()
    }

    static func currentHostSyncCount() -> Int {
        hostSyncCount
    }

    static func currentFormResultSummary() -> String {
        lastFormResultSummary
    }

    private static func currentHostSummary() -> [String: Any] {
        [
            "hostPlatform": "iOS",
            "hostSyncCount": hostSyncCount,
            "hostMessage": "This payload comes from the native iOS host.",
            "lastFormResult": lastFormResultSummary
        ]
    }

    private static func configureMethodChannel() {
        #if canImport(Flutter)
        channel?.setMethodCallHandler { call, result in
            switch call.method {
            case "getHostSummary":
                result(currentHostSummary())
            case "showNativeNotice":
                let arguments = call.arguments as? [String: Any]
                let message = arguments?["message"] as? String ?? "Flutter triggered a native message."
                showNativeAlert(message: message)
                result("native_notice_shown")
            case "closeFlutterPage":
                closeFlutterPage()
                result("flutter_page_closed")
            case "submitProfileForm":
                let arguments = call.arguments as? [String: Any] ?? [:]
                handleSubmittedProfileForm(arguments: arguments)
                result("profile_form_received")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        #endif
    }

    private static func pushHostStateToFlutter() {
        #if canImport(Flutter)
        channel?.invokeMethod("hostCounterUpdated", arguments: currentHostSummary())
        #endif
    }

    private static func showNativeAlert(message: String) {
        guard let presenter = flutterViewController else {
            return
        }

        let alertController = UIAlertController(
            title: "Native iOS Notice",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        presenter.present(alertController, animated: true)
    }

    private static func closeFlutterPage() {
        guard let navigationController = flutterViewController?.navigationController else {
            flutterViewController?.dismiss(animated: true)
            return
        }

        navigationController.popViewController(animated: true)
    }

    private static func handleSubmittedProfileForm(arguments: [String: Any]) {
        let name = arguments["name"] as? String ?? "Unknown"
        let role = arguments["role"] as? String ?? "Unknown"
        let goal = arguments["goal"] as? String ?? "Unknown"
        let newsletter = (arguments["newsletterEnabled"] as? Bool ?? false) ? "Yes" : "No"

        lastFormResultSummary = """
        Name: \(name)
        Role: \(role)
        Goal: \(goal)
        Newsletter: \(newsletter)
        """

        NotificationCenter.default.post(
            name: formResultDidUpdateNotification,
            object: nil,
            userInfo: [
                "summary": lastFormResultSummary,
                "payload": arguments
            ]
        )
    }
}
