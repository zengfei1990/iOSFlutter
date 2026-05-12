import UIKit
#if canImport(Flutter)
import Flutter
#endif

enum FlutterEntryFactory {
    static func makeViewController(initialRoute: String = "/learning", title: String = "Flutter Page") -> UIViewController {
        #if canImport(Flutter)
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return FlutterUnavailableViewController(reason: "AppDelegate 未能提供 FlutterEngine。")
        }

        let flutterViewController = FlutterViewController(
            engine: appDelegate.flutterEngine,
            nibName: nil,
            bundle: nil
        )
        flutterViewController.title = title
        flutterViewController.setInitialRoute(initialRoute)
        FlutterBridgeCoordinator.bindFlutterViewController(flutterViewController)
        return flutterViewController
        #else
        return FlutterUnavailableViewController(reason: "当前工程还没有接入 Flutter SDK 或 Flutter module。")
        #endif
    }
}

final class FlutterUnavailableViewController: UIViewController {
    private let reason: String

    init(reason: String) {
        self.reason = reason
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flutter Placeholder"
        view.backgroundColor = .systemGroupedBackground

        let titleLabel = UILabel()
        titleLabel.text = "Flutter 页面还没真正接入"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let bodyLabel = UILabel()
        bodyLabel.text = """
        \(reason)

        接好之后，这里就会变成真实的 FlutterViewController。
        """
        bodyLabel.font = .preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
