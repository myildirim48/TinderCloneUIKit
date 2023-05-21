//
//  SettingsViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 20.05.2023.
//

import UIKit

enum SettingsSection: Int, CaseIterable {
case name, profession, age, bio, ageRange
    
    var description:String {
        switch self {
        case .name: return "Name"
        case .profession: return "Profession"
        case .age: return "Age"
        case .bio: return "Bio"
        case .ageRange: return "Sekking Age Range"
        }
    }
}
struct SettingsViewModel {
    
    private let user: User
    let section: SettingsSection
    
    let placeholderText: String
    var value: String?
    
    var shouldHideInputField: Bool{
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge ?? 18)
    }
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge ?? 60)
    }
    
    func minAgeLabelText(forValue value: Float) -> String{
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String{
        return "Max: \(Int(value))"
    }
    
    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section
        
        placeholderText = "Enter \(section.description.lowercased())"
        
        switch section {
        case .name:
            value = user.fullName
        case .profession:
            value = user.profession
        case .age:
            value = String(user.age)
        case .bio:
            value = user.bio
        case .ageRange:
                break
        }
    }
}
