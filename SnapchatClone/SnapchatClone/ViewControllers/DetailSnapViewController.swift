//
//  DetailSnapViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 29/03/22.
//

import UIKit
import Firebase
import SDWebImage
class DetailSnapViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var count: UILabel!
    var snap = Snaps()
    var timerCount = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let url = URL(string: snap.urlImage)
        
        imageSnap.sd_setImage(with: url) { (image, erro, cache, url) in
            if erro == nil{
                self.descriptionLabel.text = self.snap.description
                //print("show image")
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    self.timerCount -= 1
                    self.count.text = "\(self.timerCount)"
                    //para a contagem
                    if self.timerCount == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }else{
                print("Deu erro!")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Assim que a view for fechada irá fazer oque tem aqui dentro, nesse caso vai apagar o snap
        let auth = Auth.auth()
        if let idUserSigner = auth.currentUser?.uid {
            let database = Database.database().reference()
            let user = database.child("users")
            
            let snaps = user.child(idUserSigner).child("snaps")
            //remove snap
            snaps.child(snap.identifier).removeValue()
            //remove image from snap
            let storage = Storage.storage().reference()
            let image = storage.child("image")
            
            image.child("\(snap.idImage).jpg").delete { (erro) in
                if erro == nil{
                    print("Sucesso ao excluir snap")
                }else{
                    print("Erro ao excluir!!!")
                }
            }
        }
    }
    
}
