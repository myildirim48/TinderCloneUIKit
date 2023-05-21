//
//  SettingsCell.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 16.05.2023.
//

import UIKit

protocol SettingsCellDelegate:  AnyObject {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String,
                      for section: SettingsSection)
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRange sender: UISlider)
}

class SettingsCell: UITableViewCell, ResuseIdentifierProtocol {
    
    //MARK: -  Properties
    
    var viewModel: SettingsViewModel! {
        didSet { configure() }
    }
    
    weak var delegate: SettingsCellDelegate?
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    let inputField: UITextField = {
        let textfield = SettingTextField()
        textfield.borderStyle = .none
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.placeholder = "Enter Name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var sliderStack = UIStackView()
    
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()
    
    lazy var minAgeSlider = createAgeRangeSlider()
    lazy var maxAgeSlider = createAgeRangeSlider()
    
    //MARK: -  Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        configureSlider()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Helpers
    
    func configureSlider() {
        
        
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel,minAgeSlider])
        minStack.spacing = 24
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel,maxAgeSlider])
        maxStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack,maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        
        contentView.addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(leading: leadingAnchor,trailing: trailingAnchor,padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        
    }
    
    func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleAgeRangeChanged), for: .valueChanged)
        return slider
    }
    
    func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        inputField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
        
        
        
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
    }
    
    //MARK: - Actions
    
    @objc fileprivate func handleAgeRangeChanged(sender: UISlider){
        if sender == minAgeSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
        }else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
        }
        
        delegate?.settingsCell(self, wantsToUpdateAgeRange: sender )
    }
    
    @objc fileprivate func handleUpdateUserInfo(sender: UITextField){
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    //MARK: - Custom TextField
    
    class SettingTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 100, height: 44)
        }
    }
    
}
