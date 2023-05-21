//
//  CardView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 17.05.2023.
//

import UIKit

enum SwipeDirection:Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    private let gradient = CAGradientLayer()
    private let viewModel: CardViewModel
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "info_icon") .withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
     init(viewModel: CardViewModel) {
         self.viewModel = viewModel
         super.init(frame: .zero)
        configureGestureRecognizers()
        
        infoLabel.attributedText = viewModel.userInfoText
         
        imageView.downloadImage(fromUrl: viewModel.firstImageUrl)

        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGradient()

        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
         infoButton.anchor(leading: infoLabel.trailingAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradient.frame = self.frame

    }
    
    //MARK: -  Helpers
    func configureGradient() {
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5,1.1]
        layer.addSublayer(gradient)
    }
    
    func configureGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChangePhotoTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDissmisCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            
            if shouldDissmisCard {
                let xTranslation = CGFloat(direction.rawValue) * 100
                let offScreenTransfrom = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransfrom
            }else {
                
                    self.transform = .identity
            }
            
        } completion: { _ in
            if shouldDissmisCard {
                
                    self.removeFromSuperview()
                
            }
        }

    }
    
    func panCard(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 0.2) {
            self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)

        }
        
    }
    
    //MARK: -  Actions
    @objc fileprivate func handlePanGesture(sender: UIPanGestureRecognizer){
        
        switch sender.state {
        case .began:
            super.subviews.forEach { $0.layer.removeAllAnimations() }
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default:
            break
        }
        
    }
    
    @objc fileprivate func handleChangePhotoTapGesture(sender: UITapGestureRecognizer){
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        }else {
            viewModel.showPreviousPhoto()
        }
        
//        imageView.image = viewModel.imageToShow
    }
}
