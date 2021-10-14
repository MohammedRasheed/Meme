//
//  ViewController.swift
//  Meme1
//
//  Created by Malrasheed on 10/10/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {	
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var topTextInput: UITextField!
    @IBOutlet weak var buttomTextInput: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var buttomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickView.backgroundColor = UIColor.black
        self.shareButton.isEnabled = false
        // top text
        setupTextField(textField: self.topTextInput, text: "UP")
        // buttom text
        setupTextField(textField: self.buttomTextInput, text: "BUTTOM")
        
        // Cick allow the user to exit text input after clicking anywhere in the screan
        let click: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(click)
    }
    
    func setupTextField(textField: UITextField, text: String) {
        textField.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0
        ]
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
    }
    
    // Close the keyboard when the user pressed return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Empty the text when the user start editing
        if textField.text == "UP" || textField.text == "BUTTOM"{
            textField.text = ""
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Check if the camera is avaible in the user device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.navigationController?.isNavigationBarHidden = true
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.camera)
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        self.shareButton.isEnabled = true
        present(pickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save(memeImage: memedImage)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if view.frame.origin.y == 0 && self.buttomTextInput.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage {
        self.topToolBar.isHidden = true
        self.buttomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topToolBar.isHidden = false
        self.buttomToolBar.isHidden = false
        
        return memedImage
    }
    
    func save(memeImage: UIImage) {
        let meme = Meme(topText: self.topTextInput.text!, buttomText: self.buttomTextInput.text!, originalImage: self.imagePickView.image!, memedImage: memeImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

