//
//  loginVC.swift
//  crmIOS
//
//  Created by Phi Anh on 6/27/19.
//  Copyright © 2019 Phi Anh. All rights reserved.
//
import TransitionButton
import UIKit
import Alamofire

class loginVC: UIViewController {

    @IBOutlet weak var loginBtn: TransitionButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var errorTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        errorTxt.text = ""
        if(self.usernameTxt.text == "" || self.passTxt.text == "") {
            errorTxt.text = "Không đủ thông tin đăng nhập"
        } else {
            loginBtn.startAnimation()
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.sync {
                guard let usern = self.usernameTxt.text, self.usernameTxt.text != "" else { return }
                guard let pass = self.passTxt.text, self.passTxt.text != "" else { return }
                AuthService.instance.userLogin(username: usern, password: pass, completion: { (success) in
                    if success {
                        print("logged In")
                        AuthService.instance.getToken(username: usern, password: pass, completion: {
                            (success) in
                            debugPrint(success)
                           print("got token")
                        })
                        self.loginBtn.stopAnimation(animationStyle: .expand, completion: {
                            print("Animation 1 stopped")
                        })
                    } else {
                        print(success)
                        self.loginBtn.stopAnimation(animationStyle: .shake, completion: {
                            print("Animation 2 stopped")
                            self.errorTxt.text = "Sai thông tin đăng nhập"
                        })
                    }
                })
            }
            
        }
    }

}
