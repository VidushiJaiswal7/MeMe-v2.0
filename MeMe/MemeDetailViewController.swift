//
//  MemeDetailViewController.swift
//  MeMe
//
//  Created by VIdushi Jaiswal on 01/09/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    // MARK: Properties
     var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
 
    
    // MARK: Life Cycle
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController!.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    
    }



