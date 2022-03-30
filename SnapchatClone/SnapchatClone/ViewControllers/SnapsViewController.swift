//
//  SnapsViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 25/03/22.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    

    

    var snapsArrays: [Snaps] = []
    
    override func viewDidLoad() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        super.viewDidLoad()
        
        let auth = Auth.auth()
        //recupera os dados dos usuarios
        if let idUserSigner = auth.currentUser?.uid{
            
            let database = Database.database().reference()
            let users = database.child("users")
            //pega os snaps apenas do usuario logado
            let snaps = users.child(idUserSigner).child("snaps")
            
            //Cria um ouvinte um raca pra informar se tem mudança
            snaps.observe(DataEventType.childAdded) { (snapshot) in
                
                //dicionario de data
                let data = snapshot.value as? NSDictionary
                let snap = Snaps()
                snap.identifier = snapshot.key
                snap.name = data?["name"] as! String
                snap.description = data?["description"] as! String
                snap.urlImage = data?["urlImage"] as! String
                snap.idImage = data?["idImage"] as! String
                
                self.snapsArrays.append(snap)
                
                print(self.snapsArrays )
                self.tableview.reloadData()
            }
        }
        
        
    
    }
    
    @IBAction func sigOut(_ sender: Any) {
        
        //FAZ UM ALERTA QUE ELE SERA DESLOGADO, DE ACORDO COM A RESPOSTA CANCELA O SIGOUT OU FAZ
        let auth = Auth.auth()
        
        let alertController = UIAlertController(title: "Atenção você está deslogando!", message:  "Deseja continuar?", preferredStyle: .alert)
       
        let sim = UIAlertAction(title: "Sim", style: .default) { (sim) in
            //sigOut
            do {
                try auth.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch {
                print("Erro ao deslogar")
            }
            //end sigOut
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        alertController.addAction(cancel)
        alertController.addAction(sim)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snapsArrays.count == 0{
            return 1
        }
        return snapsArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if snapsArrays.count == 0{
            var context = cell.defaultContentConfiguration()
            context.text = "Não há Snaps!!!"
            cell.contentConfiguration = context
        }else{
            let snap = self.snapsArrays[indexPath.row]
            var context = cell.defaultContentConfiguration()
            context.text = snap.name
            cell.contentConfiguration = context
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if snapsArrays.count > 0{
            let snap = self.snapsArrays[indexPath.row]
            self.performSegue(withIdentifier: "detailSegue", sender: snap)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            
            let detailSnapViewController = segue.destination as! DetailSnapViewController
            detailSnapViewController.snap = sender as! Snaps
        }
            
    }
      
}
