//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Elena Kulakova on 2019-02-23.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK:Properties
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = loadMemes()
        self.collectionView.reloadData()
        
    }
 
        //MARK: Private Methods
        
    func loadMemes() -> [Meme] {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.memes
            }else{
                return [Meme]()
            }
        }

    // MARK: Collection view

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let meme = self.memes[indexPath.row]
        
        if let memeCell = cell as? MemeCollectionViewCell {
            memeCell.memeImageView.image =  meme.memedImage
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController {
            vc.meme = memes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
