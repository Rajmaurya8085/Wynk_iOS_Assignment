//
//  Dependencies.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation

final class Dependencies {
    var container: [ObjectIdentifier: Service] = [:]
    
    private init(){
        
    }
    
    @_functionBuilder struct ModuleBuilder {
        public static func buildBlock(_ services: Service...) -> [Service] {
            services
        }
        public static func buildBlock(_ service: Service) -> Service { service }
    }
    
    convenience init(@ModuleBuilder _ services: () -> [Service]) {
        self.init()
        services().forEach { register($0) }
    }
    
    convenience init(@ModuleBuilder _ service: () -> Service) {
        self.init()
        register(service())
    }
    
    deinit {
        container.removeAll()
    }
}

extension Dependencies {
    static var main: Dependencies!
    
    func get<T>(type: T.Type ) ->  T {
        return resolve(type: type)
    }

    func build() {
        Self.main = self
    }
}

extension Dependencies {
    func resolve<T>(type: T.Type) -> T {
        guard var service = self.container[ObjectIdentifier(type)] else {
            fatalError("Dependency '\(Service.self)' not resolved!")
        }
        guard let instance = service.instance, service.lifeCycle == .single else {
            service.instance = service.createInstance(d: self)
            self.container[service.name] = service
            return service.instance as! T
        }
        
        return instance as! T
    }
        
    func register(_ service: Service) {
        print(service.name);
        self.container[service.name] = service
    }
}
