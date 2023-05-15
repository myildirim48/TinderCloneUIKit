//
//  Bindable.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 15.05.2023.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping(T?) -> ()){
        self.observer = observer
    }
}
