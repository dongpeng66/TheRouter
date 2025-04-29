//
//  HomeViewController.swift
//  TheRouterDeoms
//
//  Created by BJSTTLP185 on 2025/4/29.
//

import UIKit

class HomeViewController: UIViewController, Routable {
    
    static var route: String = "home"
    
    static func handle(parameters: [String: Any]?) {
        print("跳转到首页")
        if let params = parameters {
            print("参数：\(params)")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
