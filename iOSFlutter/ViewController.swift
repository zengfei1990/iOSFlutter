import UIKit

final class HostHomeViewController: UIViewController {
    private let introLabel = UILabel()
    private let detailsLabel = UILabel()
    private let openFlutterButton = UIButton(type: .system)
    private let stepsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iOS Host"
        view.backgroundColor = .systemBackground
        configureViews()
        buildLayout()
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

        stepsLabel.text = """
        接下来你只需要：
        1. 安装 Flutter SDK
        2. 创建 Flutter module
        3. 把 iOS 宿主接到 FlutterEngine
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
}
