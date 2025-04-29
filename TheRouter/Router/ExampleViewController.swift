import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "首页"
        
        setupUI()
        setup()
    }
    
    private func setupUI() {
        let pushButton = UIButton(type: .system)
        pushButton.setTitle("Push到详情页", for: .normal)
        pushButton.addTarget(self, action: #selector(pushToDetail), for: .touchUpInside)
        
        let presentButton = UIButton(type: .system)
        presentButton.setTitle("Present模态页", for: .normal)
        presentButton.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [pushButton, presentButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func pushToDetail() {
//        let parameters = ["title": "详情页", "id": "123"]
//        RouterManager.shared.navigate(to: "detail", parameters: parameters)
        testNavigation()
    }
    
    @objc private func presentModal() {
        let parameters = ["title": "模态页"]
        RouterManager.shared.navigate(to: "modal", parameters: parameters, navigationType: .present)
    }
    
    
    @objc private func setup() {
        // 手动注册路由
        HomeViewController.register()
        
        // 自动注册路由
        ProfileViewController.autoRegister()
        
        // 动态注册路由
        RouterManager.shared.registerDynamic(route: "dynamic/:id") { parameters in
            print("处理动态路由")
            if let params = parameters {
                print("参数：\(params)")
            }
        }
    }
    
    @objc private func testNavigation() {
        // 使用URL参数跳转
//        let url = URL(string: "profile/:userId?name=John&age=25")!
//        let parameters = RouterManager.shared.getParameters(from: url)
//        RouterManager.shared.navigate(to: "profile/:userId", parameters: parameters)
        
        
        RouterManager.shared.openURL(url: "profile/:userId?name=John&age=25", parameters: ["type": "test"], navigationType: .push)
        
        // 使用自定义参数跳转
        let customParams = ["title": "首页", "showBack": true] as [String : Any]
        RouterManager.shared.navigate(to: "home", parameters: customParams)
        
        // 动态路由跳转
        RouterManager.shared.navigate(to: "dynamic/456", parameters: ["type": "test"])
    }
}

class DetailViewController: UIViewController, RouteConfigurable {
    private var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func configure(with parameters: [String: Any]?) {
        if let title = parameters?["title"] as? String {
            self.title = title
        }
        if let id = parameters?["id"] as? String {
            self.id = id
        }
    }
}

class ModalViewController: UIViewController, RouteConfigurable {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configure(with parameters: [String: Any]?) {
        if let title = parameters?["title"] as? String {
            self.title = title
        }
    }
    
    @objc private func close() {
        NavigationManager.shared.dismiss()
    }
}

