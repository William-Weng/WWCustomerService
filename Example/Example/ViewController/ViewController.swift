//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/10/29.
//

import UIKit
import WWCustomerService

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWCustomerService.shared.settings(delegate: self, isAppStoreOpenInside: true)
    }
    
    @IBAction func callPhone(_ sender: Any) {
        WWCustomerService.shared.open(serviceType: .phone(number: "+886800092000"))
    }
    
    @IBAction func sendSMS(_ sender: Any) {
        WWCustomerService.shared.open(serviceType: .sms(recipient: "+88628825252", body: "Hello, SMS! 💬"))
    }
    
    @IBAction func sendMail(_ sender: Any) {
        WWCustomerService.shared.open(serviceType: .mail(address: "service@google.com", subject: "Hello!", body: "Hello, Mail! 💌"))
    }
    
    @IBAction func sendLineMessage(_ sender: Any) {
        WWCustomerService.shared.open(serviceType: .line(message: "Hello, LINE! 👋"))
    }
    
    @IBAction func sendWhatsAppMessage(_ sender: Any) {
        WWCustomerService.shared.open(serviceType: .whatsapp(message: "Hello, WhatsApp! 🚀"))
    }
}

// MARK: - WWCustomerService.Delegate
extension ViewController: WWCustomerService.Delegate {
    
    func customerService(_ customerService: WWCustomerService, error: any Error) {
        print(error)
    }
}
