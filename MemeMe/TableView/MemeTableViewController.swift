//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Elena Kulakova on 2019-02-23.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    //MARK:Properties
    
    var memes = [Meme]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = loadMemes()
        self.tableView.reloadData()
    }
    
    //MARK: Private Methods
    
    private func loadMemes() -> [Meme] {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.memes
        }else{
            return [Meme]()
        }
    }
    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        let meme = memes[indexPath.row]
        
        if let memeCell = cell as? MemeTableViewCell {
            memeCell.memeImageView.image =  meme.memedImage
            memeCell.memeTitleLabel.text = "\(meme.topText) \(meme.bottomText)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController {
            vc.meme = memes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            memes.remove(at: indexPath.row)
            (UIApplication.shared.delegate as? AppDelegate)?.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
}
