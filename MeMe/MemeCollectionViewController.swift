//
//  MemeCollectionViewController.swift
//  MeMe
//
//  Created by VIdushi Jaiswal on 01/09/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }


    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    

    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

               self.navigationController?.navigationBar.topItem?.title = "Sent Memes"

        
        //  Flowlayout for collection view cells
        let space:CGFloat = 4.0
        let cellWidth = (view.frame.size.width - (3 * space)) / 4.0
        let cellHeight = (view.frame.size.height - (3 * space)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController!.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false

        self.collectionView?.reloadData()
    }
    

    //MARK: Delegate functions

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image
        cell.imageView?.image = meme.memedImage
      
        
        
       
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailViewController
        detailController.meme = memes[indexPath.item] as Meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    


}
