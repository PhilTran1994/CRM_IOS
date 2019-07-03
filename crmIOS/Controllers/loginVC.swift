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
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if(self.usernameTxt.text == "" || self.passTxt.text == "") {
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng điền đủ thông tin", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
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
                            self.loginBtn.stopAnimation(animationStyle: .expand, completion: {
                                print("Animation stopped")
                            })
                        })
                        self.loginBtn.stopAnimation(animationStyle: .expand, completion: {
                            print("Animation stopped")
                        })
                    } else {
                        print("error")
                    }
                })
            }
            
        }
    }

}
