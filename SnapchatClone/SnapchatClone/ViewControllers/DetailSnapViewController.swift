//
//  DetailSnapViewController.swift
//  SnapchatClone
//
//  Created by Rethink on 29/03/22.
//

import UIKit

class DetailSnapViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var count: UILabel!
    var snap = Snaps()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(snap.description)
        
        
    }
    
}
