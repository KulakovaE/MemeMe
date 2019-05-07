//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Elena Kulakova on 2019-01-27.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    
    var memeToEdit: Meme?
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black,
                                                            .foregroundColor: UIColor.white,
                                                            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                            .strokeWidth:  -4.0
                                                            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
        
        shareBarButton.isEnabled = false
        cameraBarButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if let meme = memeToEdit {
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image = meme.originalImage
            shareBarButton.isEnabled = true
        }
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
   
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    @IBAction func shareImage (_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let items = [memeImage]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(memeImage: memeImage)
                
                if let _ = self.memeToEdit,
                    let memeDetailVC = (((super.presentingViewController as? UITabBarController)?.selectedViewController) as? UINavigationController)?.topViewController as? MemeDetailViewController  { // if we edited a meme, and saved it, I want to see it. And yes, I got help!
                    memeDetailVC.popToRoot()
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
        
        present(activityViewController, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func save(memeImage: UIImage) {
        if let topText = topTextField.text, let bottomText = bottomTextField.text, let originalImage = imageView.image {
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memeImage)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.memes.append(meme)
            }
        }
    }
    
    // MARK: Render view to an image
    
    func generateMemedImage() -> UIImage {
        
        hideBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideBars(false)
        
        return memedImage
    }
    
    func hideBars(_ hide: Bool) {
        navigationController?.setToolbarHidden(hide, animated: false)
        navigationController?.setNavigationBarHidden(hide, animated: false)
    }
    
    // MARK: Keyboard Functions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomTextField.isFirstResponder { // only if the bottomTextField is activated then move the view up
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
            self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object:  nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object:  nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            self.shareBarButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
