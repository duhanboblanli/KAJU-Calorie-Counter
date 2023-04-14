//
//  PhotoPicker.swift
//  KAJU
//
//  Created by kadir on 2.03.2023.
//

import UIKit
import FirebaseAuth

final class PhotoPicker: UIViewController{
    
    private let profileRef = DatabaseSingleton.storage
    private let db = DatabaseSingleton.db
    private var userEmail = Auth.auth().currentUser?.email
    private let cellBackgColor = ThemesOptions.cellBackgColor
    private let backGroundColor = ThemesOptions.backGroundColor
    
    // MARK: -UI ELEMENTS
    private var imageView: UIImageView!
    
    private var backGroundView = {
        let button = UIButton()
        button.backgroundColor = .black
        return button
        
    }()
    private var containerView = {
        let view = UIView()
        view.backgroundColor = ThemesOptions.backGroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    private var galleryButton = {
        let button = UIButton()
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = 10
        button.accessibilityIdentifier = "Gallery"
        return button
    }()
    private var cameraButton = {
        let button = UIButton()
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = 10
        button.accessibilityIdentifier = "Camera"
        return button
    }()
    private var galleryIcon = {
        let imageView = UIImageView()
        let width = CGFloat(28)
        let height = CGFloat(24)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = ThemesOptions.figureColor
        imageView.anchor(width: width, height: height)
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        return imageView
    }()
    private var cameraIcon = {
        let imageView = UIImageView()
        let width = CGFloat(28)
        let height = CGFloat(24)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = ThemesOptions.figureColor
        imageView.anchor(width: width, height: height)
        imageView.image = UIImage(systemName: "camera")
        return imageView
    }()
    private var defaultPersonImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfilePhoto")
        imageView.tintColor = .systemGray
        return imageView
    }()
    private var galleryLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Gallery".localized()
        return label
    }()
    private var cameraLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Camera".localized()
        return label
    }()
    private var deletePPButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = ThemesOptions.buttonBackGColor
        button.accessibilityIdentifier = "Delete"
        return button
    }()
    private var imagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    // MARK: -INIT-CONTROLLER
    init(imageView: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.imageView = imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViews()
        configureLayout()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showOptions()
    }
    
    // MARK: -VIEWS CONNECTION
    func linkViews(){
        containerView.addSubview(galleryButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(galleryLabel)
        containerView.addSubview(cameraLabel)
        containerView.addSubview(deletePPButton)
        galleryButton.addSubview(galleryIcon)
        cameraButton.addSubview(cameraIcon)
    }
    
    // MARK: -CONFIGURATION
    func configureView(){
        view.backgroundColor = .clear
        imagePickerController.delegate = self
        backGroundView.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(pickPhoto(sender: )), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(pickPhoto(sender: )), for: .touchUpInside)
        deletePPButton.addTarget(self, action: #selector(pickPhoto(sender: )), for: .touchUpInside)
    }
    
    // MARK: -FUNCTIONS
    func showOptions(){
        guard let targetView = view else{return}
        targetView.addSubview(backGroundView)
        targetView.addSubview(containerView)
        backGroundView.anchor(top: targetView.topAnchor, left: targetView.leftAnchor, bottom: targetView.safeAreaLayoutGuide.bottomAnchor, right: targetView.rightAnchor)
        containerView.layer.masksToBounds = true
        UIView.animate(withDuration: 0.25, animations: {
            self.backGroundView.alpha = 0.8
        }) {(true) in
            self.containerView.anchor(left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        }
    }
    
    @objc func dismissAlert(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backGroundView.alpha = 0
        }){ done in
            if (done){
                self.containerView.removeFromSuperview()
                self.backGroundView.removeFromSuperview()
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func pickPhoto(sender: UIButton){
        switch sender.accessibilityIdentifier {
        case "Gallery":
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true)
        case "Camera":
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true)
        case "Delete":
            showSimpleAlert()
        default:
            return
        }
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Are you sure you want to Delete ?".localized(), message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            }))
        alert.addAction(UIAlertAction(title: "Delete".localized(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                //Sign out action
                self.imageView.image = self.defaultPersonImage.image
                guard let image = UIImage(named: "defaultProfilePhoto") else { return }
                self.uploadPhoto(image: image)
                self.dismissAlert()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    // MARK: -LAYOUT
    func configureLayout(){
        galleryButton
            .anchor(top: containerView.topAnchor,
                    bottom: galleryLabel.topAnchor,
                    right: containerView.centerXAnchor,
                    paddingTop: 16,
                    paddingBottom: 4,
                    paddingRight: 32)
        
        galleryIcon
            .anchor(top: galleryButton.topAnchor,
                    left: galleryButton.leftAnchor,
                    bottom: galleryButton.bottomAnchor,
                    right: galleryButton.rightAnchor,
                    paddingTop: 8,
                    paddingLeft: 8,
                    paddingBottom: 8,
                    paddingRight: 8)
        
        galleryLabel
            .anchor(top: galleryButton.bottomAnchor,
                    bottom: containerView.bottomAnchor,
                    paddingBottom: 8)
        
        cameraButton
            .anchor(top: galleryButton.topAnchor,
                    left: containerView.centerXAnchor,
                    bottom: cameraLabel.topAnchor,
                    paddingLeft: 32,
                    paddingBottom: 4)
        
        cameraIcon
            .anchor(top: cameraButton.topAnchor,
                    left: cameraButton.leftAnchor,
                    bottom: cameraButton.bottomAnchor,
                    right: cameraButton.rightAnchor,
                    paddingTop: 8,
                    paddingLeft: 8,
                    paddingBottom: 8,
                    paddingRight: 8)
        
        cameraLabel
            .anchor(top: cameraButton.bottomAnchor,
                    bottom: galleryLabel.bottomAnchor)
        
        deletePPButton
            .anchor(top: containerView.topAnchor,
                    right: containerView.rightAnchor,
                    paddingTop: 12,
                    paddingRight: 12)
        
        galleryLabel.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor).isActive = true
        cameraLabel.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor).isActive = true
    }
}

// MARK: -PHOTO PICKING AND UPLOADING
extension PhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        uploadPhoto(image: image)
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhoto(image: UIImage){
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.75),
           let email = userEmail {
            try? jpegData.write(to: imagePath)
            // Upload Image
            UserDefaults.standard.set(imageName, forKey: "\(email).profileImg")
            let path = "images/\(email).\(imageName)"
            let docRef = db.collection("UserInformations").document("\(email)")
            docRef.updateData(["profileImgURL": path])
            _ = profileRef.reference(withPath: path).putData(jpegData, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
                _ = metadata.size
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


