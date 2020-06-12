//
//  ImageLoaderProtocol.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//


import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceProtocol: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

