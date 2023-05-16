//
//  CardView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 12.05.2023.
//

import UIKit

class CardView: UIStackView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
//            imageView.image = UIImage(named: imageName)
    
            imageView.downloadImage(fromUrl: imageName)
            print(imageName)
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barview = UIView()
                barview.layer.cornerRadius = 4
                barview.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barview)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    fileprivate func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [weak self] idx,imageUrl in
            
            if let imageUrl {
                self?.imageView.downloadImage(fromUrl: imageUrl)

            }
            self?.barsStackView.arrangedSubviews.forEach({ view in
                view.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    fileprivate let informationLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barsStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    //Confgirations
    fileprivate let thershold: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        }else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupGradientLayer()
        setupBarsStackView()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually

    }
    

    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.25]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subView in
                subView.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
        
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        //        rotation
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = gesture.translation(in: nil).x > thershold || gesture.translation(in: nil).x < -thershold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { _ in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
