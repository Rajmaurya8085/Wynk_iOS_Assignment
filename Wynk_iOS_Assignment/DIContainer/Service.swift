//
//  Service.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation

struct Service {
  
    enum LifeCycle  {
        case single
        case new
    }
    
    // Life cycle for the current service
    var lifeCycle: LifeCycle
    
    // Unique Identifier
    let name: ObjectIdentifier
    var instance: Any?
    
    private let resolve: (Dependencies) -> Any
    
    func createInstance(d: Dependencies) -> Any {
        return resolve(d)
    }
    
    init<Service>(_ lifeCycle: LifeCycle = .new, resolve: @escaping (Dependencies) -> Service) {
        self.name = ObjectIdentifier(Service.self)
        self.lifeCycle = lifeCycle
        self.resolve = resolve
    }
}
