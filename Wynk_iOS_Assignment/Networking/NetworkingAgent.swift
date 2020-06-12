//
//  NetworkingAgent.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//


import Foundation
import Combine

struct NetworkingAgent :NetworkServiceType {
    
    
    func execute<T>(for request: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { result -> Response<T> in
            let value = try decoder.decode(T.self, from: result.data)
            return Response(value: value, response: result.response)
        }
        .mapError { $0 }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
            
    }
}

struct Response<T> {
    let value: T
    let response: URLResponse
}



protocol NetworkServiceType {
     func execute<T>(for request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<Response<T>, Error> where T: Decodable
}
