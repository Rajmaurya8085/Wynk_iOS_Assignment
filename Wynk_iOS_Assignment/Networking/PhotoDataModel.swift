//
//  PhotoDataModel.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation


struct PhotoList:Codable {
    var hits:[Photo]
}

struct Photo:Codable {
    let id:Double
    let pageURL:String
    let type:String
    let tags:String
    let previewURL:String?
    let previewWidth:Int
    let previewHeight:Int
    let largeImageURL:String?
    let webformatURL:String?
    let imageWidth:Int
    let imageHeight:Int
    let views:Int
    let favorites:Int
    let downloads:Int
    let likes:Int
    let comments:Int
    let user_id:Double
    let user:String
    let userImageURL:String
}
