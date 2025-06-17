import Foundation

public protocol Routable {
    static var route: String { get }
    static func handle(parameters: [String: Any]?)
}

public extension Routable {
    static func register() {
        RouterManager.shared.register(route: route) { parameters in
            handle(parameters: parameters)
        }
    }
}

//// MARK: - 自动注册
//public protocol AutoRegisterable: Routable {}
//
//public extension AutoRegisterable {
//    static func autoRegister() {
//        register()
//    }
//} 

// MARK: - 视图控制器注册,回调configure数据配置
public protocol RouteConfigurable {
    func handle(with parameters: [String: Any]?)
}
