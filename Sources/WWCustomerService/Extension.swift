//
//  Extension.swift
//  WWCustomerService
//
//  Created by William.Weng on 2025/11/12.
//

import UIKit
import StoreKit

// MARK: - UIApplication (private function)
extension UIApplication {
    
    /// 產生完整的AppStoreLink
    /// => https://itunes.apple.com/lookup?id=443904275&country=tw
    /// - itms-apps://itunes.apple.com/app/id28825252
    /// - Parameter identity: 該APP的identity
    /// - Returns: String
    func _appStoreLinkString(identity: NSNumber) -> String { return "itms-apps://itunes.apple.com/app/id\(identity)" }
    
    /// 彈出AppStroe的產品ViewController
    /// - Parameters:
    ///   - identity: 該APP的identity
    ///   - target: UIViewController
    ///   - delegate: SKStoreProductViewControllerDelegate
    ///   - result: Result<Bool, Error>
    func _presentStoreProductViewController(with identity: NSNumber, target: UIViewController, delegate: SKStoreProductViewControllerDelegate, result: @escaping (Result<Bool, Error>) -> Void) {
        
        let storeProductViewController = SKStoreProductViewController._build(with: delegate)
        let parameters = SKStoreProductViewController._iTunesItemParametersMaker(with: identity)
        
        storeProductViewController.loadProduct(withParameters: parameters) { (isSuccess, error) in
            if let error = error { result(.failure(error)) }
            result(.success(isSuccess))
        }
        
        target.present(storeProductViewController, animated: true, completion: nil)
    }
}

// MARK: - SKStoreProductViewController (static function)
extension SKStoreProductViewController {
    
    /// [建立內彈的AppStore](https://juejin.cn/post/6844903912248623111)
    /// - Parameter delegate: SKStoreProductViewControllerDelegate
    /// - Returns: SKStoreProductViewController
    static func _build(with delegate: SKStoreProductViewControllerDelegate) -> SKStoreProductViewController {
        
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = delegate
        
        return storeProductViewController
    }
    
    /// iTunes的identifier形式
    /// - Parameter identifier: NSNumber
    /// - Returns: [String: NSNumber]
    static func _iTunesItemParametersMaker(with identifier: NSNumber) -> [String: NSNumber] {
        return [SKStoreProductParameterITunesItemIdentifier: identifier]
    }
}
