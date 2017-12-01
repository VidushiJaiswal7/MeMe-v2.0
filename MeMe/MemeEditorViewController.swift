//
//  MemeEditorViewController.swift
//  MeMe
//
//  Created by VIdushi Jaiswal on 06/08/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
// 

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
  
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!

 
  
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName: -3.6]
    
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        shareButtonToBeEnabled(enabled: false)

        configure(topTextField)
        configure(bottomTextField)
        
       
    }

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        tabBarController!.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
//MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       pickAnImageFrom(.photoLibrary)

    }
    
    @IBAction func clickAnImageFromCamera(_ sender: Any) {
     pickAnImageFrom(.camera)
        
    }

    
    @IBAction func shareAnImage(_ sender: Any) {
        
            let memedImage = generateMemedImage()
        
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil )
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                
                //Save the image
                     self.save(memedImage: memedImage)
                
                //Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
              }
         }
        
        
        present(activityController, animated: true, completion:nil)
        
    }
    
    
        
    @IBAction func cancel(_ sender: Any) {
        
       /* imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareAndCancelButtonToBeEnabled(enabled: false) */
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    
    
//MARK: Delegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = image
        }
        else {
            print("Something went wrong!")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 {
            // Figure out what the new text will be, if we return true
        var newText = topTextField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
   
        }
        
            
        else if textField.tag == 2 {
            var newText = bottomTextField.text! as NSString
            newText = newText.replacingCharacters(in: range, with: string) as NSString
            
        }
      
        // returning true gives the text field permission to change its text
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      if textField.text == "TOP" || textField.text == "BOTTOM"
      {
          textField.text = ""
       }
        
  }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            textField.resignFirstResponder()
   
    return true
    }
    
    
    //MARK: Notifications
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: Helper Functions
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder
        {
          
            self.view.frame.origin.y =  getKeyboardHieght(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder
        {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHieght(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height

    }
    
    
    func generateMemedImage() -> UIImage {
        
        toolbarsToBeHidden(visible: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        

        toolbarsToBeHidden(visible: false)
        
        return memedImage
        
    }
    
    func save(memedImage: UIImage) {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        
    
       
    }
    
    func toolbarsToBeHidden(visible: Bool){
        topToolbar.isHidden = visible
        bottomToolbar.isHidden = visible
    }
    
    func shareButtonToBeEnabled(enabled: Bool) {
        shareButton.isEnabled = enabled
        
    }
    
    func configure(_ textField: UITextField) {
       
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        
        textField.text = textField.tag == 1 ? "TOP" : "BOTTOM"

    }
    
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
        shareButtonToBeEnabled(enabled: true)
    }
    
}


