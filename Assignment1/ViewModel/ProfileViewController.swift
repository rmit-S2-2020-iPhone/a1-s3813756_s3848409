//
//  ProfileViewController.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import ALCameraViewController

class ProfileViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{
    
    private var userViewModel = UserViewModel()
    
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBAction func editProfile(_ sender: UIButton) {
        editProfile()
    }
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?                       //declare necessary controller for choosing image process
    var pickImageCallback : ((UIImage) -> ())?;
    
    
    @IBOutlet var profileSumView: [UIView]!
    @IBOutlet weak var thisMonthExpense: UILabel!
    @IBOutlet weak var monthBudget: UILabel!
    @IBOutlet weak var remainingBudget: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        profileSum()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setProfilePic()
        profileSum()
        //call neccessary function that needs to be updated
    }
    
    
    //set user profile picture function
    var imagePicker = UIImagePickerController()
    
    func editUserPic() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.openPicLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default) { _ in
            self.openPhoneCamera()
        })
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User clicked Dismiss button")
        }))
        
        present(alert, animated: true)
    }
    
    func openPicLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum                              //call image picker when user click edit user image
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhoneCamera() {
        let cameraViewController = CameraViewController { [weak self] image, asset in
            self!.userImage?.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return                                                                  //get the image that user chose
        }
        userImage?.image = image                                                    //set the image after user picked the image
    }
    
    
    //set up user profile layout
    func setProfilePic() {
        userImage?.layer.borderWidth = 2
        userImage?.backgroundColor = UIColor.white
        userImage?.layer.masksToBounds = false                                      //set user image layout
        userImage?.layer.borderColor = UIColor.black.cgColor
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
        
        profileSumView?.forEach {(view) in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()                              //set style for profile page
                view.layer.cornerRadius = 10
            })
        }
    }
    
    func editProfile() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit User Name", style: .default) { _ in
            self.editName()
        })
        
        alert.addAction(UIAlertAction(title: "Choose User Image", style: .default) { _ in
            self.editUserPic()
        })
        
        alert.addAction(UIAlertAction(title: "Change Budget", style: .default) { _ in
            self.changeBudget()
        })
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User clicked Dismiss button")
        }))
        
        present(alert, animated: true)
    }
    
    
    //edit user name
    func editName() {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))                   //call alert function when editname function is triggered
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."                                           //set a textfield for user input
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.userViewModel.changeUserName(alert.textFields?.first?.text ?? "User")
            self.profileSum()
                                                     //set a button after finish editing
        }))
        
        self.present(alert, animated: true)
    }
    
    
    //calculate expense for this month
    func profileSum() {
        let (userCurrentName, monthAmount, remainBudget, userBudget) = userViewModel.getProfileSum()
        remainingBudget?.text = remainBudget                                                    //set those values to label
        thisMonthExpense?.text = monthAmount
        monthBudget?.text = userBudget
        userName?.text = userCurrentName
    }
    
    
    
    //user budget function
    func changeBudget() {
        let alert = UIAlertController(title: "Please enter your budget below", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))                                   //alert message
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your budget here..."                                                         //set a textfield for the alert
            textField.keyboardType = .decimalPad                                                                        //set keyboard type for textfield
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in            //add done action after user finished adding budget
            let strCheck:String = alert.textFields!.first!.text!
            if (strCheck.trim() == "" || strCheck.trim() == "."){
                self.popUpAlert(withTitle: "Error", message: "Please enter a value.")                           //check for user's incorrect input
            }else {
                let dotCount = strCheck.filter({ $0 == "." }).count
                if ( dotCount > 1) {
                    self.popUpAlert(withTitle: "Error", message: "Value is invalid.")
                }else {
                    self.userViewModel.changeBudget(strCheck)
                    self.profileSum()
                }
            }                                                                                                   //set new user budget to label
        }))
        
        self.present(alert, animated: true)
    }

}
