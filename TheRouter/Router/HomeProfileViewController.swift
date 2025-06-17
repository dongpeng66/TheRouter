//
//  HomeProfileViewController.swift
//  TheRouter
//
//  Created by BJSTTLP185 on 2025/4/29.
//


import UIKit

class HomeProfileViewController: UIViewController, RouteConfigurable {
    func handle(with parameters: [String : Any]?) {
        print("跳转到个人资料页")
        if let params = parameters {
            print("参数：\(params)")
        }
    }
    
    
    static var route: String = "homeProfile/:userId"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }


}
