//
//  LoginModel.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 08/11/21.
//

import Foundation

public struct LoginRequest:Encodable {
    public let phone_number = AppUtils.getLoginPhoneNumber()
    public let password = "123456"
    
    public init() {
        
    }
}

public struct LoginResponse:Decodable {
    public let idToken:Token?
    public struct Token:Decodable {
        public let jwtToken:String?
    }
}

public struct RegisterRequest:Encodable {
    let phone_number:String = AppUtils.getLoginPhoneNumber() ?? ""
    let password:String = "123456"
    
    public init() {
        
    }
}
