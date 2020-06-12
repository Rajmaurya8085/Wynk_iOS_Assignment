//
//  PhotoServiceProtocol.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation
import Combine

// You are free to change the method signature
protocol PhotoServiceProtocol {
    func fetchPhotoList(searchQueury:String, pageNo:String)->AnyPublisher<PhotoList , Error>
   
}

