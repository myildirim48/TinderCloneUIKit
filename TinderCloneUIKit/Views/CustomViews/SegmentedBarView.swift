//
//  SegmentedBarView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 23.05.2023.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            barView.layer.cornerRadius = 2
            barView.clipsToBounds = true
            addArrangedSubview(barView)
        }
        
        spacing = 10
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index:Int)  {
        arrangedSubviews.forEach { $0.backgroundColor = .barDeselectedColor }
        arrangedSubviews[index].backgroundColor = .white
    }
}
