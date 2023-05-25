//
//  MatchHeaderView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 25.05.2023.
//

import UIKit

protocol MatchHeaderDelegate: AnyObject {
    func matchHeader(_ header: MatchHeaderView, wantsToSendMessageTo uid: String)
}

class MatchHeaderView: UICollectionReusableView {
    
    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: MatchHeaderDelegate?
    
    private let newMatchesLabel: UILabel = {
        let label = UILabel()
        label.text = "New Matched"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MatchHeaderCell.self, forCellWithReuseIdentifier: MatchHeaderCell.reuseIdentifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newMatchesLabel)
        newMatchesLabel.anchor(top: topAnchor, leading: leadingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 0))
        
        addSubview(collectionView)
        collectionView.anchor(top: newMatchesLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                              padding: .init(top: 4, left: 12, bottom: 24, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - CollectionView Datasource
extension MatchHeaderView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchHeaderCell.reuseIdentifier, for: indexPath) as! MatchHeaderCell
        cell.viewModel = MatchHeaderCellViewModel(match: matches[indexPath.row])
        return cell
    }
    
    
}
//MARK: - CollectionView Delegate
extension MatchHeaderView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = matches[indexPath.row].uid
        delegate?.matchHeader(self, wantsToSendMessageTo: uid )
    }
}

//MARK: - CollectionView FlowLayout
extension MatchHeaderView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
}
