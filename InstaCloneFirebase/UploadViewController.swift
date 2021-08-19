//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Sötnos on 19.8.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        // Create and add a gesture recognizer to the view
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    // Function to choose an image from the photolibrary
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    // Image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - IBAction
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        // Upload data to Firebase
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
        
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                                                       
                            let imageUrl = url?.absoluteURL
                            
                            // DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageURL" : imageUrl!.absoluteString, "postedBy" : Auth.auth().currentUser?.email! ?? "no email", "postComment" : self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                
                                if error != nil {
                                    // If error
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "battle.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        } else {
                            print("error: \(error?.localizedDescription ?? "error")")
                        }
                    }
                }
            }
        }
    }
}
