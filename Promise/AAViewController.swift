//
//  AAViewController.swift
//  Promise
//
//  Created by 박중선 on 2023/10/31.
//

import UIKit
import SwiftSMTP

class AAViewController: UIViewController {
    
    let smtp = SMTP(
        hostname: "smtp.gmail.com",
        email: "wndtjszx@gmail.com",
        password: "zgpt rpta abtr fhga",
        port: 587,
        tlsMode: .requireSTARTTLS
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        sendVerificationCode(to: "1997pjdsdsassds@naver.com", code: generateVerificationCode())
        
    }
    
    func generateVerificationCode() -> String {
        return String(Int.random(in: 100000...999999))
    }
    
    func sendVerificationCode(to email: String, code: String) {
        let from = Mail.User(name: "약속이", email: "wndtjszx@gmail.com")
        let to = Mail.User(email: email)

        let mail = Mail(from: from, to: [to], subject: "Your verification code", text: "Your verification code is: \(code)")

        smtp.send(mail) { error in
            if let error = error {
                print("Failed to send email: \(error)")
            } else {
                print("Email sent successfully!")
            }
        }
    }



}
