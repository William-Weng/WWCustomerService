//
//  WWCustomerService.swift
//  WWCustomerService
//
//  Created by William.Weng on 2025/10/29.
//

import UIKit
import MessageUI
import StoreKit

// MARK: - 常用的客服聯絡工具
open class WWCustomerService: NSObject {
    
    public protocol Delegate: AnyObject {
        func customerService(_ customerService: WWCustomerService, error: Error)
    }
    
    @MainActor
    public static let shared = WWCustomerService()
    
    private var isAppStoreOpenInside: Bool = false
    private weak var delegate: (UIViewController & Delegate)?
    
    deinit {
        delegate = nil
    }
}

// MARK: - 公開函式
public extension WWCustomerService {
    
    /// 相關參數設定
    /// - Parameters:
    ///   - delegate: UIViewController & Delegate
    ///   - isAppStoreOpenInside: AppStore頁面是否在APP裡面顯示？
    func settings(delegate: (UIViewController & Delegate), isAppStoreOpenInside: Bool = false) {
        self.isAppStoreOpenInside = isAppStoreOpenInside
        self.delegate = delegate
    }
    
    /// 開啟相關服務
    /// - Parameter serviceType: ServiceType
    func open(serviceType: ServiceType) {
        switch serviceType {
        case .sms(recipient: let recipient, body: let body): sendSMS(recipient: recipient, body: body)
        case .mail(address: let address, subject: let subject, body: let body): sendMail(address: address, subject: subject, body: body)
        case .phone(number: let number): callPhone(number: number)
        case .line, .whatsapp: sendToInstantMessaging(with: serviceType)
        }
    }
}

extension WWCustomerService: MFMessageComposeViewControllerDelegate {}
extension WWCustomerService: SKStoreProductViewControllerDelegate {}

// MARK: - MFMessageComposeViewControllerDelegate
public extension WWCustomerService {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 主工具
private extension WWCustomerService {
    
    /// 傳送簡訊 (+886800092000)
    /// - Parameters:
    ///   - recipient: 對方的電話號碼
    ///   - body: 簡訊內容
    func sendSMS(recipient: String, body: String) {
        
        guard let target = delegate,
              MFMessageComposeViewController.canSendText()
        else {
            delegate?.customerService(self, error: CustomError.unsupportedService); return
        }
        
        let controller = MFMessageComposeViewController()
        
        controller.recipients = [recipient]
        controller.body = body
        controller.messageComposeDelegate = self
        
        target.present(controller, animated: true, completion: nil)
    }
    
    /// 打電話 (+88628825252)
    /// - Parameter number: 電話號碼
    func callPhone(number: String) {
        
        guard let url = URL(string: "tel://\(number)"),
              UIApplication.shared.canOpenURL(url)
        else {
            delegate?.customerService(self, error: CustomError.unsupportedService); return
        }
        
        UIApplication.shared.open(url)
    }
    
    /// 寄送eMail (service@google.com)
    /// - Parameters:
    ///   - address: 對方的電子信箱地址
    ///   - subject: 信件主題
    ///   - body: 信件內容
    func sendMail(address: String, subject: String, body: String) {
        
        let payload = "mailto:\(address)?subject=\(subject)&body=\(body)"
        
        guard let url = URL(string: payload),
              UIApplication.shared.canOpenURL(url)
        else {
            delegate?.customerService(self, error: CustomError.unsupportedService); return
        }
        
        UIApplication.shared.open(url)
    }
    
    /// 傳送給即時通訊APP
    /// - Parameter type: ServiceType
    func sendToInstantMessaging(with type: ServiceType) {
        
        guard let appId = type.appId(),
              let scheme = type.urlScheme(),
              let message = type.message()
        else {
            delegate?.customerService(self, error: CustomError.incompleteInformation); return
        }
        
        sendToInstantMessaging(scheme: scheme, appId: appId, message: message)
    }
}

// MARK: - 小工具
private extension WWCustomerService {
    
    /// 傳送給即時通訊APP (LINE / WhatsAPP)
    /// - Parameters:
    ///   - scheme: 該APP的scheme
    ///   - appId: 該APP的appId
    ///   - message: 傳送的訊息樣式
    func sendToInstantMessaging(scheme: String, appId: NSNumber, message: String) {
        
        guard let schemeURL = URL(string: scheme),
              let messageURL = URL(string: message),
              UIApplication.shared.canOpenURL(schemeURL),
              UIApplication.shared.canOpenURL(messageURL)
        else {
            if !isAppStoreOpenInside { openAppStoreWithOutside(appId: appId); return }
            openAppStoreWithInside(appId: appId); return
        }
        
        UIApplication.shared.open(messageURL, options: [:], completionHandler: nil)
    }
    
    /// 在外部開啟AppStore頁面
    /// - Parameter appId: NSNumber
    func openAppStoreWithOutside(appId: NSNumber) {
        
        let appUrlString = UIApplication.shared._appStoreLinkString(identity: appId)
        
        guard let appStoreURL = URL(string: appUrlString) else { delegate?.customerService(self, error: CustomError.unsupportedService); return }
        
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    /// 在內部開啟AppStore頁面
    /// - Parameter appId: NSNumber
    func openAppStoreWithInside(appId: NSNumber) {
        
        guard let target = delegate else { return }
        
        UIApplication.shared._presentStoreProductViewController(with: appId, target: target, delegate: self) { result in
            switch result {
            case .failure(let error): target.customerService(self, error: error)
            case .success(let isSussess): print(isSussess)
            }
        }
    }
}
