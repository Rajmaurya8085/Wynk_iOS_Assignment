//
//  Inject.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    private var service: T?
    
    init(){}
    
    var wrappedValue: T {
        mutating get {
        service ?? {
            service =  Dependencies.main.get(type: T.self)
                return service!
                }()
        }
        
    }
}
