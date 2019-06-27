//
//  loginVC.swift
//  crmIOS
//
//  Created by Phi Anh on 6/27/19.
//  Copyright © 2019 Phi Anh. All rights reserved.
//
import TransitionButton
import UIKit

class loginVC: UIViewController {

    @IBOutlet weak var loginBtn: TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        loginBtn.startAnimation()
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
