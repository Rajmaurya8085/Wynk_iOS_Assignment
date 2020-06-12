//
//  Publisher+Extension.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}


extension UIStoryboard{
    
    class func loadViewController<T:UIViewController>(storyBoardName:String,identifierVC:String,type:T.Type) -> T
    {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: identifierVC) as! T
        return controller
    }
}
