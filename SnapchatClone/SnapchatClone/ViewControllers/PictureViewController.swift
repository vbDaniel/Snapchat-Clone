//
//  PictureViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 25/03/22.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var confirmedText: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    //GERADOR DE ID RANDOM
    var imageID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    
        self.confirmedText.isEnabled = false
        self.confirmedText.backgroundColor = UIColor.systemGray

        
    }
    

    
    @IBAction func choosePic(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let imageRecover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picture.image = imageRecover
        
        //Habilita buttuom confirm
        self.confirmedText.isEnabled = true
        self.confirmedText.backgroundColor = UIColor(red: 0.486, green: 0.344, blue: 0.702, alpha: 1)
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirmedButton(_ sender: Any) {
        self.confirmedText.isEnabled = false
        self.confirmedText.setTitle( "Carregando...", for: .normal)
        
        let store =  Storage.storage().reference()
        let folderImage = store.child("image")
        
        let imageStore = folderImage.child("\(self.imageID).jpg")
        
        
        
        if let imageSelected = picture.image{

            if let dataImage = imageSelected.jpegData(compressionQuality: 0.5){
                
                imageStore.putData(dataImage, metadata: nil) { (metaData, erro) in
                   
                    if erro == nil{
                    //recuperando a url da imagem que foi upada
                    imageStore.downloadURL(completion: { (url, error) in

                    if let urlR = url?.absoluteString {

                        //mandando o usuario para tela de lista de usuarios, e passando a URL para ser recuperada la
                        self.performSegue(withIdentifier: "userSelectSegue", sender: urlR)

                    }

                    })
                            
                        self.confirmedText.isEnabled = false
                        self.confirmedText.setTitle( "Confirmar", for: .normal)
                    }else{
                        print("Deu erro mano!!! \(String(describing: erro?.localizedDescription))")
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSelectSegue"{
            let userViewController = segue.destination as! UsersTableViewController
            
            userViewController.descriptionImage = self.descriptionField.text!
            userViewController.urlImage =  sender as! String
            userViewController.idImage = self.imageID
        }
    }
}
