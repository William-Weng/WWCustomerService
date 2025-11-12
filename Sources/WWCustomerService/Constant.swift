//
//  Constant.swift
//  WWCustomerService
//
//  Created by William.Weng on 2025/11/12.
//

import Foundation

// MARK: - enum
public extension WWCustomerService {
    
    /// 自定義錯誤
    enum CustomError: Error {
        case unsupportedService     // 不支援該服務
        case unsupportedUrl         // 不支援該URL
        case incompleteInformation  // 資訊給得不完整
    }
    
    /// 可選用的服務
    enum ServiceType {
        
        case sms(recipient: String, body: String)
        case mail(address: String, subject: String, body: String)
        case phone(number: String)
        case line(message: String)
        case whatsapp(message: String)
        
        /// APP的Scheme
        /// - Returns: String?
        func urlScheme() -> String? {
            switch self {
            case .phone: return "tel://"
            case .sms: return "sms://"
            case .mail: return "mailto://"
            case .line: return "line://"
            case .whatsapp: return "whatsapp://"
            }
        }
        
        /// AppStore的Id
        /// - Returns: NSNumber?
        func appId() -> NSNumber? {
            switch self {
            case .phone, .sms, .mail: return nil
            case .line: return 43904275
            case .whatsapp: return 310633997
            }
        }
        
        /// 要傳送的訊息編碼
        /// - Returns: String?
        func message() -> String? {
            switch self {
            case .phone, .sms, .mail: return nil
            case .line(message: let message):
                guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
                return "https://line.me/R/share?text=\(encodedMessage)"
            case .whatsapp(message: let message):
                guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
                return "whatsapp://send?text=\(encodedMessage)"
            }
        }
    }
}
