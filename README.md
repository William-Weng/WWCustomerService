# WWCustomerService
[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWCustomerService) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [An integrated tool for handling commonly used customer service communication tools.](https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller)
- [處理一般客服常用的連絡工具的整合工具。](https://ithelp.ithome.com.tw/articles/10280629)

https://github.com/user-attachments/assets/452f3153-e02d-40aa-b899-099b50864f40

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWCustomerService.git", .upToNextMajor(from: "1.0.0"))
]
```

### 可用函式 (Function)
|函式|功能|
|-|-|
|settings(delegate:isAppStoreOpenInside:)|相關參數設定|
|open(serviceType:)|開啟相關服務|

### Example
```swift
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

extension ViewController: WWCustomerService.Delegate {
    
    func customerService(_ customerService: WWCustomerService, error: any Error) {
        print(error)
    }
}
```
