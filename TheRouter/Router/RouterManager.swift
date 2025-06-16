import Foundation
import UIKit

public class RouterManager {
    public static let shared = RouterManager()
    private var routes: [String: RouteHandler] = [:]
    private var dynamicRoutes: [String: RouteHandler] = [:]
    private var viewControllerMap: [String: UIViewController.Type] = [:]
    private var viewControllerDynamicRoutes: [String: RouteHandler] = [:]
    
    private init() {}
    
    // MARK: - 路由注册
    public func register(route: String, handler: @escaping RouteHandler) {
        routes[route] = handler
    }
    
    public func registerDynamic(route: String, handler: @escaping RouteHandler) {
        dynamicRoutes[route] = handler
    }
    
    // MARK: - 视图控制器注册
    public func register<T: UIViewController>(route: String, viewControllerType: T.Type) {
        viewControllerMap[route] = viewControllerType
    }
    public func registerDynamicVC<T: UIViewController>(route: String, viewControllerType: T.Type, handler: @escaping RouteHandler) {
        viewControllerMap[route] = viewControllerType
        viewControllerDynamicRoutes[route] = handler
    }
    
    // MARK: - 路由跳转
    public func navigate(to route: String, parameters: [String: Any]? = nil, navigationType: NavigationType = .push) {
        // 先尝试处理普通路由
        if let handler = routes[route] {
            handler(parameters)
            return
        }
        
        // 尝试匹配动态路由
        for (pattern, handler) in dynamicRoutes {
            if match(pattern: pattern, with: route) {
                handler(parameters)
                return
            }
        }
        
        // 尝试处理视图控制器路由
        if let viewControllerType = viewControllerMap[route] {
            let viewController = viewControllerType.init()
            if let configurable = viewController as? RouteConfigurable {
                configurable.configure(with: parameters)
            }
            
            // 尝试匹配动态路由
            for (pattern, handler) in viewControllerDynamicRoutes {
                if match(pattern: pattern, with: route) {
                    handler(parameters)
                }
            }
            
            switch navigationType {
            case .push:
                NavigationManager.shared.push(viewController)
            case .present:
                NavigationManager.shared.present(viewController)
            }
            return
        }
        
        print("未找到匹配的路由: \(route)")
    }
    
    // MARK: - 路由跳转,并解析URL,分割URL和URL里面的参数
    public func openURL(url urlString: String, parameters: [String: Any]? = nil, navigationType: NavigationType = .push) {
        guard let url = URL(string: urlString) else { return }
        let route = getUrlPath(from: url)
        let pa = getParameters(from: url)
        var paramas: [String: Any] = [:]
        if let parametersD = parameters, !parametersD.isEmpty {
            for item in parametersD {
                paramas[item.key] = item.value
            }
        }
        // 合并后保留原值（pa 中的 key，value 不变）
        if !pa.isEmpty {
            for item in pa {
                paramas[item.key] = item.value
            }
        }
        if let rout = route, !rout.isEmpty {
            navigate(to: rout, parameters: paramas, navigationType: navigationType)
        }
    }
    
    // MARK: - 路由匹配 homeProfile/:userId?name=John&age=25
    private func match(pattern: String, with route: String) -> Bool {
        let patternComponents = pattern.components(separatedBy: "/")
        let routeComponents = route.components(separatedBy: "/")
        
        guard patternComponents.count == routeComponents.count else {
            return false
        }
        
        for (patternComponent, routeComponent) in zip(patternComponents, routeComponents) {
            if patternComponent.hasPrefix(":") {
                continue
            }
            if patternComponent != routeComponent {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - 获取URL参数
    public func getParameters(from url: URL) -> [String: Any] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters: [String: Any] = [:]
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
    // MARK: - 获取URL Path
    public func getUrlPath(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.path
    }
}

public typealias RouteHandler = ([String: Any]?) -> Void

public enum NavigationType {
    case push
    case present
}
