//
//  ProfileViewController.swift
//  TheRouterDeoms
//
//  Created by BJSTTLP185 on 2025/4/29.
//

import UIKit

class ProfileViewController: UIViewController, AutoRegisterable, RouteConfigurable {
    func configure(with parameters: [String : Any]?) {
        print("跳转到个人资料页")
        if let params = parameters {
            print("参数：\(params)")
        }
    }
    
    
    static var route: String = "profile/:userId"
    
    static func handle(parameters: [String: Any]?) {
        print("跳转到个人资料页")
        if let params = parameters {
            print("参数：\(params)")
        }
        let viewController = ProfileViewController.init()
        if let configurable = viewController as? RouteConfigurable {
            configurable.configure(with: parameters)
        }
        NavigationManager.shared.push(viewController)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }


}
