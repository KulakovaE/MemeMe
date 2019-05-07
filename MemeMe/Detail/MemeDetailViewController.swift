//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Elena Kulakova on 2019-02-23.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
    
    func popToRoot() {
        presentedViewController?.dismiss(animated: true, completion: {
             self.navigationController?.popToRootViewController(animated: true)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let meme = meme {
            if segue.identifier == "editMeme"{
                if let navigation = segue.destination as? UINavigationController,let editor = navigation.topViewController as? MemeEditorViewController{
                    editor.memeToEdit = meme
                }
            }
        }
    }
}
