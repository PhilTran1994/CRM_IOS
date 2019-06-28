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
        loginBtn.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async {
            guard let usern = self.usernameTxt.text, self.usernameTxt.text != "" else { return }
            guard let pass = self.passTxt.text, self.passTxt.text != "" else { return }
            AuthService.instance.userLogin(username: usern, password: pass, completion: { (success) in
                if success {
                    print("logged In")
                    AuthService.instance.getToken(username: usern, password: pass, completion: {
                        (success) in
                        debugPrint(success)
                        
                    })
                    self.loginBtn.stopAnimation(animationStyle: .expand, completion: {
                        print("done")
                    })
                } else {
                    print("error")
                }
            })
        }
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                button.stopAnimation(animationStyle: .expand, completion: {
                    let secondVC = UIViewController()
                    self.present(secondVC, animated: true, completion: nil)
                })
            })
        })
    }

}
