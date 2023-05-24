//
//  MatchView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 24.05.2023.
//

import UIKit

protocol MatchViewDelegate: AnyObject {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User)
}

class MatchView: UIView {
    
    //MARK: -  Properties
    private let viewModel: MatchViewModel
    
    weak var delegate: MatchViewDelegate?
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let matchedUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    
    private let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    private let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let visiualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton]
    
    //MARK: - Lifecycle
    init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        loadMatchData()
        
        addActions()
        configureBlurView()
        configureUI()
        configureAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    
    func loadMatchData() {
        descriptionLabel.text = viewModel.matchLabelText
        
        currentUserImageView.downloadImage(fromUrl: viewModel.currentUserImageUrl)
        matchedUserImageView.downloadImage(fromUrl: viewModel.matchedUserImageUrl)
    }
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 0
        }
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
        
        descriptionLabel.anchor(leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0))
        
        currentUserImageView.anchor(trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 75
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(leading: centerXAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 75
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48))
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48))
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func configureBlurView()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissAll))
        visiualEffectView.addGestureRecognizer(tap)
        
        addSubview(visiualEffectView)
        visiualEffectView.fillSuperview()
        visiualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.visiualEffectView.alpha = 1
        }
    }
    
    func addActions()  {
        sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        keepSwipingButton.addTarget(self, action: #selector(handleDismissAll), for: .touchUpInside)
    }
    
    func configureAnimations()  {
        views.forEach { $0.alpha = 1 }
         
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0,options: .calculationModeCubic) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.45) {
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }
    }
    
    //MARK: - Actions
    @objc fileprivate func handleSendMessage() {
        delegate?.matchView(self, wantsToSendMessageTo: viewModel.matchedUser)
    }
    
    @objc fileprivate func handleDismissAll() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
