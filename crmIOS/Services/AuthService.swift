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
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH':'mm':'ss 'GMT'"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        dateFormatter.locale = Locale(identifier: Calendar.current.timeZone.identifier)
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd/MM/YYYY HH':'mm':'ss "///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: Calendar.current.timeZone.identifier)
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    func checkLogin() -> Bool {
        debugPrint("Check token----------------------------------------------------------")
        if(self.defaults.string(forKey: "access_token") != nil ) {
            if(self.defaults.string(forKey: "expires") != nil) {
                debugPrint("The token-----------------------------------------------------------------------------------")
                let toDay = NSDate()
                let dateLocal = self.defaults.string(forKey: "expires")
                var dateLocalString = ""
                for charac in dateLocal ?? "" {
                    let record = dateLocalString + String(charac)
                    dateLocalString = record
                    debugPrint(dateLocalString)
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH':'mm':'ss 'GMT'"
                dateFormatter.timeZone  = NSTimeZone(name: "GMT") as TimeZone?
                let dateInLocal = dateFormatter.date(from: dateLocalString)
                debugPrint(self.defaults.string(forKey: "expires") ?? "Test")
                return ((dateInLocal as! Date) > toDay as Date)
            } else {
                return false
            }
        } else {
           return false
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
                var tokRec = ""
                let todayDate = NSDate()
                for charac in expires! {
                    let record = rec + String(charac)
                    rec = record
                }
                for tok in token! {
                    let record = tokRec + String(tok)
                    tokRec = record
                }
                let formattedDate  = dateFormatter.date(from: rec)
                let convertedDate = self.convertDateFormatter(date: rec)
                if (token != nil && token != "" ) {
                    self.defaults.set(tokRec, forKey: "access_token" )
                    self.defaults.set(rec,forKey: "expires")
                    debugPrint(self.defaults.string(forKey: "access_token") ?? "Test")
                    debugPrint(self.defaults.string(forKey: "expires") ?? "Test1")
                }
                debugPrint(todayDate)
                debugPrint(convertedDate)
                debugPrint(formattedDate as Any)
            }
        }
    }
}
