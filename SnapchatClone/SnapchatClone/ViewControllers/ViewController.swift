//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let auth = Auth.auth()
        auth.addStateDidChangeListener {(auth, user) in
            //Se o usuario já estive logado,vai ser direcionado para a main
            if let userLogin = user{
                self.performSegue(withIdentifier: "loggedUser", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false) //TIRA A BARRA DE NAVEGAÇÃO
    }

}

