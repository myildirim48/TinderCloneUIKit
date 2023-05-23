//
//  ProfileController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 21.05.2023.
//

import UIKit

protocol ProfileControllerDelegate: AnyObject {
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)
}

class ProfileController: UIViewController {
    //MARK: -  Properties
    private let user: User
    
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var viewModel = ProfileViewModel(user: user)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        return cv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let dissmisButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageUrls.count)
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: -  Buttons
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }
    
    private let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    private let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    private let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    
    //MARK: -  Lifecycle
    
    init(user:User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        loadUserData()
    }
    
    //MARK: - Actions
    
    @objc fileprivate func handleDismissAll() {
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleLike() {
        delegate?.profileController(self, didLikeUser: user)
    }
    
    @objc fileprivate func handleDislike() {
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc fileprivate func handleSuperlike() {
        
    }
    
    //MARK: - Helpers
    
    func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(dissmisButton)
                
        dissmisButton.addTarget(self, action: #selector(handleDismissAll), for: .touchUpInside)
        dissmisButton.setDimensions(height: 40, width: 40)
        dissmisButton.anchor(top: collectionView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -20, left: 0, bottom: 0, right: 16 ))
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel,professionLabel,bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding:.init(top: 12, left: 12, bottom: 0, right: 12))
        
        configureBottomControls()
        configureBarStackView()
        configureTopBlurView()
    }
    
    func configureTopBlurView() {
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    func configureBarStackView(){
        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 62, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func configureBottomControls()  {
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        superLikeButton.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [dislikeButton,superLikeButton,likeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)

        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,padding: .init(top: 0, left: 0, bottom: 32, right: 0))
    }

}
//MARK: - CollectionView Delegate
extension ProfileController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
}
//MARK: - CollectionView DataSource
extension ProfileController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        cell.imageView.downloadImage(fromUrl: viewModel.imageUrls[indexPath.row])
        return cell
    }
}
//MARK: - CollectionView FlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
