//
//  AboutUsController.swift
//  KAJU
//
//  Created by kadir on 4.03.2023.
//

import UIKit

final class AboutUsController: UIViewController{
    
    private let backGroundColor = ThemesOptions.backGroundColor
    
    // MARK: -UI ELEMENTS
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.backgroundColor = ThemesOptions.backGroundColor
        return scrollView
    }()
    private lazy var containerView = {
        return UIView()
    }()
    private lazy var aboutUsImageView = {
        let imageView = UIImageView()
        let height = CGFloat(300)
        imageView.anchor(height: height)
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "about-us")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var aboutUsDesc = {
        let textView = UITextView()
        let height = CGFloat(120)
        textView.anchor(height: height)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.text = Texts.aboutString
        return textView
    }()
    private lazy var socialMediaContainer = {
        let view = UIView()
        let height = CGFloat(80)
        view.anchor(height: height)
        return view
    }()
    private lazy var facebookButton = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: size)
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.accessibilityIdentifier = "facebook"
        return button
    }()
    private lazy var instagramButton = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: size)
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.accessibilityIdentifier = "instagram"
        return button
    }()
    private lazy var twitterButton = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: size)
        button.setImage(UIImage(named: "twitter"), for: .normal)
        button.accessibilityIdentifier = "twitter"
        return button
    }()
    private lazy var discordButton = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: size)
        button.setImage(UIImage(named: "discord"), for: .normal)
        button.accessibilityIdentifier = "discord"
        return button
    }()
    private lazy var appVersionContainer = {
        let view = UIView()
        let height = CGFloat(50)
        view.anchor(height: height)
        return view
    }()
    private lazy var appVersionLabel = {
        let label = UILabel()
        label.text = "App Version".localized()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    private lazy var appVersionValue = {
        let label = UILabel()
        label.text = "0.0.1"
        label.textColor = .white
        return label
    }()
    private lazy var descTitle = {
        let label = UILabel()
        let height = CGFloat(50)
        label.anchor(height: height)
        label.text = "About KAJU".localized()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    private lazy var spacer = {
        let view = UIView()
        let height = CGFloat(80)
        view.anchor(height: height)
        return view
    }()
    private lazy var policyButton: UIButton = {
        let policyBText = UILabel()
        let button = UIButton()
        let height = CGFloat(80)
        button.addSubview(policyBText)
        button.anchor(height: height)
        policyBText.text = "Terms of Use & Privacy Policy".localized()
        policyBText.anchor(left: button.leftAnchor, paddingLeft: 24)
        policyBText.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        policyBText.font = UIFont.systemFont(ofSize: 20)
        policyBText.textColor = .white
        return button
    }()
    
    // MARK: -VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViews()
        viewDidLayoutSubviews()
        configureView()
    }
    
    // MARK: -VIEWS CONNECTION
    func linkViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(aboutUsImageView)
        containerView.addSubview(aboutUsDesc)
        containerView.addSubview(socialMediaContainer)
        containerView.addSubview(policyButton)
        containerView.addSubview(descTitle)
        containerView.addSubview(appVersionContainer)
        containerView.addSubview(spacer)
        appVersionContainer.addSubview(appVersionLabel)
        appVersionContainer.addSubview(appVersionValue)
        socialMediaContainer.addSubview(facebookButton)
        socialMediaContainer.addSubview(instagramButton)
        socialMediaContainer.addSubview(twitterButton)
        socialMediaContainer.addSubview(discordButton)
    }
    
    // MARK: -CONFUGURATION
    func configureView(){
        navigationItem.largeTitleDisplayMode = .never
        policyButton.accessibilityIdentifier = "policy"
        facebookButton.addTarget(self, action: #selector(goToTheLink(sender: )), for: .touchUpInside)
        instagramButton.addTarget(self, action: #selector(goToTheLink(sender: )), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(goToTheLink(sender: )), for: .touchUpInside)
        discordButton.addTarget(self, action: #selector(goToTheLink(sender: )), for: .touchUpInside)
        policyButton.addTarget(self, action: #selector(goToTheLink(sender: )), for: .touchUpInside)
        addTopBorder(to: policyButton)
        addTopBorder(to: spacer)
    }
    
    // MARK: -FUNCTIONS
    @objc func goToTheLink(sender: UIButton){
        switch sender.accessibilityIdentifier {
        case "facebook":
            print("dac")
            return
        case "instagram":
            return
        case "twitter":
            return
        case "discord":
            return
        case "policy":
            return
        default:
            return
        }
    }
    
    // MARK: -LAYOUT
    override func viewDidLayoutSubviews() {
        scrollView
            .anchor(top: view.topAnchor,
                    left: view.leftAnchor,
                    bottom: view.bottomAnchor,
                    right: view.rightAnchor)
        
        containerView
            .anchor(top: scrollView.contentLayoutGuide.topAnchor,
                    left: scrollView.contentLayoutGuide.leftAnchor,
                    bottom: scrollView.contentLayoutGuide.bottomAnchor,
                    right: scrollView.contentLayoutGuide.rightAnchor,
                    width: view.frame.width)
        
        aboutUsImageView
            .anchor(top: containerView.topAnchor,
                    left: containerView.leftAnchor,
                    right: containerView.rightAnchor)
        
        descTitle
            .anchor(top: aboutUsImageView.bottomAnchor,
                    left: aboutUsImageView.leftAnchor,
                    bottom: aboutUsDesc.topAnchor,
                    right: aboutUsDesc.rightAnchor,
                    paddingTop: 16,
                    paddingLeft: 19)
        
        aboutUsDesc
            .anchor(top: descTitle.bottomAnchor,
                    left: containerView.leftAnchor,
                    right: containerView.rightAnchor,
                    paddingLeft: 16, paddingRight: 16)
        
        socialMediaContainer
            .anchor(top: aboutUsDesc.bottomAnchor,
                    paddingTop: 32)
        
        facebookButton
            .anchor(left: socialMediaContainer.leftAnchor,
                    paddingLeft: 16)
        
        instagramButton
            .anchor(left: facebookButton.rightAnchor,
                    paddingLeft: 32)
        
        twitterButton
            .anchor(left: instagramButton.rightAnchor,
                    paddingLeft: 32)
        
        discordButton
            .anchor(left: twitterButton.rightAnchor,
                    right: socialMediaContainer.rightAnchor,
                    paddingLeft: 32,
                    paddingRight: 16)
        
        appVersionContainer
            .anchor(top: socialMediaContainer.bottomAnchor,
                    left: containerView.leftAnchor,
                    right: containerView.rightAnchor,
                    paddingTop: 32)
        
        appVersionLabel
            .anchor(top: appVersionContainer.topAnchor,
                    left: appVersionContainer.leftAnchor,
                    paddingLeft: 24)
        
        appVersionValue
            .anchor(top: appVersionLabel.bottomAnchor,
                    left: appVersionLabel.leftAnchor,
                    bottom: appVersionContainer.bottomAnchor)

        policyButton
            .anchor(top: appVersionContainer.bottomAnchor,
                    left: containerView.leftAnchor,
                    right: containerView.rightAnchor,
                    paddingTop: 16)
        
        spacer
            .anchor(top: policyButton.bottomAnchor,
                    left: containerView.leftAnchor,
                    bottom: containerView.bottomAnchor,
                    right: containerView.rightAnchor)
        
        socialMediaContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: socialMediaContainer.centerYAnchor).isActive = true
        instagramButton.centerYAnchor.constraint(equalTo: socialMediaContainer.centerYAnchor).isActive = true
        twitterButton.centerYAnchor.constraint(equalTo: socialMediaContainer.centerYAnchor).isActive = true
        discordButton.centerYAnchor.constraint(equalTo: socialMediaContainer.centerYAnchor).isActive = true
    }
}

extension UIViewController {
    func addTopBorder(to view: UIView) {
        let thickness: CGFloat = 0.5
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: thickness)
        topBorder.backgroundColor = UIColor.systemGray.cgColor
        view.layer.addSublayer(topBorder)
    }
}

extension UIView {
    func addTopBorder(to view: UIView, width: CGFloat) {
        let thickness: CGFloat = 0.5
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: width, height: thickness)
        topBorder.backgroundColor = UIColor.systemGray.cgColor
        view.layer.addSublayer(topBorder)
    }
}
    

