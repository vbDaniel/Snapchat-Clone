//
//  LoginViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func login(_ sender: Any) {
        if let email = self.email.text{
            if let password = self.password.text{
                let auth = Auth.auth()
                auth.signIn(withEmail: email, password: password) { (user, erro) in
                    
                    if erro == nil{
                        
                        if user == nil{
                            let alert = Alert(title: "Erro ao autenticar", message: "Verifique os dados e tente novamente!")
                            self.present(alert.getAlert(), animated: true, completion: nil)
                        }else{
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                        
                    }else{
                        let alert = Alert(title: "Erro ao fazer login", message: "Verifique os dados e tente novamente!")
                        self.present(alert.getAlert(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
 
}
