//
//  Alert.swift
//  SnapchatClone
//
//  Created by Rethink on 28/03/22.
//

import UIKit

class Alert{
    
    var title: String
    var message : String
    
    init(title: String, message: String){
        self.title = title
        self.message = message
        
        
    }
    
    func getAlert() -> UIAlertController{
        let alertController = UIAlertController(title: title, message:  message, preferredStyle: .alert)
       
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        return alertController
    }
}

