//
//  NetworkComponent.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation

extension PhotoService {
struct PhotoAPI {
  static let scheme = "https"
  static let host = "pixabay.com"
  static let path = "/api/"
  static let key = "16900288-73e5a3dc4ccafc92b72be2c37"
}

    func makeNowplayingURlComponents(searchString:String , pageNo: String
) -> URLComponents {
  var components = URLComponents()
  components.scheme = PhotoAPI.scheme
  components.host = PhotoAPI.host
  components.path = PhotoAPI.path
        
  components.queryItems = [
    URLQueryItem(name: "key", value: PhotoAPI.key),
    URLQueryItem(name: "q", value: searchString),
    URLQueryItem(name: "image_type", value: "photo"),
    URLQueryItem(name: "pretty", value: "true"),
    URLQueryItem(name: "page", value: pageNo)
  ]
  return components
}

}
