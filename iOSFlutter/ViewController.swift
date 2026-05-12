import UIKit

final class HostHomeViewController: UIViewController {
    private let introLabel = UILabel()
    private let detailsLabel = UILabel()
    private let openFlutterButton = UIButton(type: .system)
    private let openFlutterFormButton = UIButton(type: .system)
    private let syncStateButton = UIButton(type: .system)
    private let syncCountLabel = UILabel()
    private let lastFormResultLabel = UILabel()
    private let stepsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iOS Host"
        view.backgroundColor = .systemBackground
        configureViews()
        buildLayout()
        startObservingFlutterResults()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureViews() {
        introLabel.text = "这是原生 iOS 宿主页。你可以从这里跳到 Flutter 页面，体验 add-to-app 的接入方式。"
        introLabel.font = .preferredFont(forTextStyle: .title3)
        introLabel.textColor = .label
        introLabel.numberOfLines = 0

        detailsLabel.text = "当前项目已经改成代码化导航结构，方便后面接入共享 FlutterEngine、路由参数和双端联调。"
        detailsLabel.font = .preferredFont(forTextStyle: .body)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.numberOfLines = 0

        var configuration = UIButton.Configuration.filled()
        configuration.title = "打开 Flutter 页面"
        configuration.image = UIImage(systemName: "arrow.right.circle.fill")
        configuration.imagePadding = 8
        configuration.cornerStyle = .large
        openFlutterButton.configuration = configuration
        openFlutterButton.addTarget(self, action: #selector(openFlutterPage), for: .touchUpInside)

        var formConfiguration = UIButton.Configuration.filled()
        formConfiguration.title = "打开 Flutter 表单页"
        formConfiguration.image = UIImage(systemName: "square.and.pencil")
        formConfiguration.imagePadding = 8
        formConfiguration.cornerStyle = .large
        openFlutterFormButton.configuration = formConfiguration
        openFlutterFormButton.addTarget(self, action: #selector(openFlutterFormPage), for: .touchUpInside)

        var syncConfiguration = UIButton.Configuration.tinted()
        syncConfiguration.title = "同步原生状态到 Flutter"
        syncConfiguration.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        syncConfiguration.imagePadding = 8
        syncConfiguration.cornerStyle = .large
        syncStateButton.configuration = syncConfiguration
        syncStateButton.addTarget(self, action: #selector(syncHostStateToFlutter), for: .touchUpInside)

        syncCountLabel.font = .preferredFont(forTextStyle: .subheadline)
        syncCountLabel.textColor = .secondaryLabel
        syncCountLabel.numberOfLines = 0
        updateSyncCountLabel()

        lastFormResultLabel.font = .preferredFont(forTextStyle: .subheadline)
        lastFormResultLabel.textColor = .label
        lastFormResultLabel.numberOfLines = 0
        lastFormResultLabel.layer.cornerRadius = 12
        lastFormResultLabel.clipsToBounds = true
        lastFormResultLabel.backgroundColor = .secondarySystemBackground
        lastFormResultLabel.textAlignment = .left
        updateLastFormResultLabel()

        stepsLabel.text = """
        学习建议：
        1. 先从原生页进入 Flutter
        2. 再从原生页进入 Flutter 表单流
        3. 观察 Flutter 如何把结果回传给原生
        """
        stepsLabel.font = .preferredFont(forTextStyle: .footnote)
        stepsLabel.textColor = .secondaryLabel
        stepsLabel.numberOfLines = 0
    }

    private func buildLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            introLabel,
            detailsLabel,
            openFlutterButton,
            openFlutterFormButton,
            syncStateButton,
            syncCountLabel,
            lastFormResultLabel,
            stepsLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func openFlutterPage() {
        let viewController = FlutterEntryFactory.makeViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func openFlutterFormPage() {
        let viewController = FlutterEntryFactory.makeViewController(
            initialRoute: "/profile-form",
            title: "Flutter Form"
        )
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func syncHostStateToFlutter() {
        FlutterBridgeCoordinator.incrementHostSyncCount()
        updateSyncCountLabel()
    }

    private func updateSyncCountLabel() {
        syncCountLabel.text = "原生已主动同步 \(FlutterBridgeCoordinator.currentHostSyncCount()) 次状态到 Flutter。"
    }

    private func updateLastFormResultLabel() {
        lastFormResultLabel.text = "最近一次 Flutter 表单结果：\n\(FlutterBridgeCoordinator.currentFormResultSummary())"
    }

    private func startObservingFlutterResults() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFlutterFormResultUpdated),
            name: FlutterBridgeCoordinator.formResultDidUpdateNotification,
            object: nil
        )
    }

    @objc
    private func handleFlutterFormResultUpdated() {
        updateLastFormResultLabel()
    }
}
