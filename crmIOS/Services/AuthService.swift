//
//  AuthService.swift
//  crmIOS
//
//  Created by Phi Anh on 6/28/19.
//  Copyright © 2019 Phi Anh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userName : String {
        get {
            return defaults.value(forKey: USER_NAME) as! String
        }
        set {
            return defaults.set(newValue, forKey: USER_NAME)
        }
    }
    func userLogin(username : String, password : String, completion:
        @escaping CompletionHandler) {
        let lowerUsername = username.lowercased()
        let body : [String: Any]  = [
            "username": lowerUsername,
            "password": password
        ]
        Alamofire.request(LOGIN_URL, method: .post, parameters: body,
                          encoding: JSONEncoding.default,headers: header).responseJSON
            { (response) in
                if response.error == nil {
                    guard let data = response.data  else { return }
                    let json = try? JSON(data: data)
                    let success = json?["Success"].boolValue
                    if(success == true) {
                        debugPrint("Đã vào")
                        self.isLoggedIn = true
                        completion(true)
                    } else {
                        self.isLoggedIn = false
                        completion(false)
                    }
                    
                } else {
                    completion(false)
                    debugPrint(response.error as Any)
            }
        }
    }
    func getToken(username: String, password: String, completion:
        @escaping CompletionHandler) {
        let lowerUsername = username.lowercased()
        let body : [String: Any]  = [
            "username": lowerUsername,
            "password": password,
            "grant_type" : "password"
        ]
        Alamofire.request(TOKEN_URL, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: tokenHeader).responseJSON { (response) in
            if response.error == nil {
                guard let data = response.data else { return }
                let json = try? JSON(data: data)
                let token = json?["access_token"].stringValue
                let expires = json?[".expires"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH':'mm':'ss 'GMT'"
                dateFormatter.timeZone  = NSTimeZone(name: "GMT") as TimeZone?
                var rec = ""
                for charac in expires! {
                    debugPrint(charac)
                    let record = rec + String(charac)
                    rec = record
                }
                let date = NSDate()
                let formattedDate  = dateFormatter.date(from: rec)
                let toDate = dateFormatter.date(from: "Sun, 27 Oct 2019 03:54:26 GMT")
                debugPrint(token as Any)
                debugPrint(expires as Any)
                debugPrint(rec)
                debugPrint(toDate as Any)
                debugPrint(date)
                debugPrint(formattedDate as Any)
            }
        }
    }
}
