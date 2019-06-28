//
//  Constants.swift
//  crmIOS
//
//  Created by Phi Anh on 6/27/19.
//  Copyright © 2019 Phi Anh. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success : Bool) -> ()
//URL Contants
let BASE_URL = "http://democrm.hoanggiahan.com:8080"
let LOGIN_URL = "\(BASE_URL)/login"
let TOKEN_URL = "\(BASE_URL)/Token"
let REMINDER_ODATA_URL = "\(BASE_URL)/odata/Reminder"
let CUSTOMER_ODATA_URL = "\(BASE_URL)/odata/Customer"
let BIKE_ODATA_UR = "\(BASE_URL)/odata/BikeType"
let BIKE_CODE_ODATA_URL = "\(BASE_URL)/odata/BikeCode"
let BIKE_COLOR_ODATA_URL = "\(BASE_URL)/odata/BikeColor"
let REMINDER_DETAILS_ODATA_URL = "\(BASE_URL)/odata/ReminderDetail"
let TODAY_REMINDER_ODATA_URL = "\(BASE_URL)/odata/NotiInDay"
let USER_ACCOUNT_ODATA_URL = "\(BASE_URL)/odata/UserAccount"
let CHECK_REMINDER_CUSTOMER_URL = "\(BASE_URL)/Json/CheckReminderCustomer"

//Segues
let TO_LOGIN = "toLogin"
let TO_MAIN = "toMain"

//user Defeaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_NAME = "userName"

//Headers
let header = [
    "Content-Type" : "Application/json; charset=utf-8;"
]
let tokenHeader = [
    "Content-Type": "application/x-www-form-urlencoded"
]
