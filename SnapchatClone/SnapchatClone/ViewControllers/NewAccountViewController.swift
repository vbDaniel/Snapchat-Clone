//
//  NewAccountViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmedPassword: UITextField!
    @IBOutlet weak var name: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    

    @IBAction func newAccountButton(_ sender: Any) {
        
        if let email = self.email.text {
            if let name = self.name.text {
                if let password = self.password.text {
                    if let confirmedPassword = self.confirmedPassword.text{
                        
                        
                        //Email validation
                        
                        //Password validation
                        if password == confirmedPassword{
                            print("Senhas iguais, OK!!!")
                            //Name validation
                            if name != ""{
                                //CRIAR A CONTA DO USUARIO NO FIREBASE
                                
                                let auth = Auth.auth()
                                auth.createUser(withEmail: email, password: password) { (user, erro) in
                                    if erro == nil{
                                        if user == nil{
                                            let alert = Alert(title: "Erro ao autenticar", message: "Verifique os dados e tente novamente!")
                                            self.present(alert.getAlert(), animated: true, completion: nil)
                                        }else{
                                            
                                            let dataBase = Database.database().reference()
                                            let user = dataBase.child("users")
                                            let userID = Auth.auth().currentUser!.uid
                                            let userData = ["name": name, "e-mail": email]
                                            
                                            user.child(userID).setValue(userData)
                                            
                                            self.performSegue(withIdentifier: "newAccountSegue", sender: nil)
                                        }
                                    }else{
                                        print("Erro ao cadastrar user \(String(describing: erro?.localizedDescription))")
                                        
                                        let erroRecover = erro! as NSError
                                        let codErro = erroRecover.localizedDescription
                                            
                                            
                                            print("Erro: \(String(describing: codErro))")
                                            var showError = ""
                                            
                                            
                                            switch (codErro){
                                                
                                            case "The email address is badly formatted.":
                                                showError = "O email foi digitado em um formato incorreto"
                                                break
                                                
                                            case "The email address is already in use by another account.":
                                                showError = "Esse email já está em uso!"
                                                break
                                                
                                            case "The password must be 6 characters long or more.":
                                                showError = "As senhas devem ser acima de 6 caracteres(min: 3 letras e 3 números"
                                                break
                                                
                                            default:
                                                showError = "Erro ainda não definido!"
                                            }
                                            //"The email address is badly formatted."
                                            //"The email address is already in use by another account."
                                            //"The password must be 6 characters long or more."
                                            
                                            //Alerta de erros
                                            let alert = Alert(title: "Erro ao cadastrar usuário", message: "Confira os dados pois: \(showError)")
                                            self.present(alert.getAlert(), animated: true, completion: nil)
                                            
                                        
                                    }
                                }
                                //end autenticação
                                
                            }else{
                                let alert = Alert(title:  "Adicione seu nome!!!", message: "Digite seu nome para continuar")
                                self.present(alert.getAlert(), animated: true, completion: nil)
                            }
                            
                            
                        }else{
                            print("senhas diferentes tente novamente")
                            // colocar um alert
                            let alert = Alert(title:  "ATENÇÃO digite senhas IGUAIS!!!", message: "Suas senhas não são iguais")
                            self.present(alert.getAlert(), animated: true, completion: nil)
                            
                        }
                        //end
                    }
                }
            }
        }
    }
    
}
