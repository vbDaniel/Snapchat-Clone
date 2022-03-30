//
//  SnapsTableViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 28/03/22.
//

import UIKit
import Firebase


class UsersTableViewController: UITableViewController {
    
    var usersArray: [User] = []
    var urlImage = ""
    var descriptionImage = ""
    var idImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = Database.database().reference()
        let users = database.child("users")
        
        // adicionar um evento sempre que um novo usuario for adicionado
        users.observe(DataEventType.childAdded) { (snapshot) in
            let data = snapshot.value as? NSDictionary
            
            
            //Recupera data users logados
            let auth = Auth.auth()
            let idUserSigner = auth.currentUser?.uid
            
            //Recuper dados
            
            let nameUser = data!["name"] as! String
            let emailUser = data!["e-mail"] as! String
            let idUser = snapshot.key
            
            let user = User(email: emailUser, name: nameUser, uid: idUser)
            
            //add no array
            if idUser != idUserSigner{
                self.usersArray.append(user)
            }
        
            //Atualiza o reload data
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let userRecover = self.usersArray[indexPath.row]
        cell.textLabel?.text = userRecover.name
        cell.detailTextLabel?.text = userRecover.email
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectUser = self.usersArray[indexPath.row]
        
        let idSelect = selectUser.uid
        
        let database = Database.database().reference()
        let users = database.child("users")
        
        let snaps = users.child(idSelect).child("snaps")
        
        //REcuperar dados do usuario que está logado
        
        let auth = Auth.auth()
        if  let idUserSigner = auth.currentUser?.uid{
            
            let  userSigner = users.child(idUserSigner)
            userSigner.observeSingleEvent(of: DataEventType.value) { (snapshot) in
                
                let data = snapshot.value as? NSDictionary
                
                //Dicionario com as infos de delivery dos snaps
                let snap = [
                    "from": data?["e-mail"],
                    "name": data?["name"],
                    "description": self.descriptionImage,
                    "urlImage": self.urlImage,
                    "idImage": self.idImage
                ]
                snaps.childByAutoId().setValue(snap)
                
                self.navigationController?.popViewController(animated: true)            }
        }
        
        
       
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
