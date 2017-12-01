//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by VIdushi Jaiswal on 01/09/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    var memes: [Meme] {
    return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 100.0
        
  
    }

 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController!.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false

        self.tableView.reloadData()
    }
    
    //MARK: Delegate functions

 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.memes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as!  MemeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
      
        cell.label?.text = meme.topText! + "..." + meme.bottomText!
        cell.memeImage?.image = meme.memedImage
        
       
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     let object: AnyObject = storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC")
     let detailVC = object as! MemeDetailViewController
     
     //Populate view controller with data from the selected item
      detailVC.meme = memes[indexPath.row] as Meme
        
     //Present the view controller using navigation
     navigationController!.pushViewController(detailVC, animated: true)
     }



    
    
 

}
