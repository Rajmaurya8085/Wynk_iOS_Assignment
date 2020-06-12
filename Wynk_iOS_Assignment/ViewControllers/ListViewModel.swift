//
//  ListViewModel.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine


protocol updateDelegate:class {
    func didReceivedData()
}

protocol PhotoListProtocol {
    func getPhotos(searchString:String)
    func loadMorePhotos(searchString:String)
    func loadImage(for photo: Photo, size: ImageSize) -> AnyPublisher<UIImage?, Never>
    var photos:[Photo]{get set}
    var delegate:updateDelegate? { get set }
    func getSuggestedList(searchString:String)->[String]
    
}

class PhotoListViewModel:PhotoListProtocol{
    @Inject private var photoService: PhotoServiceProtocol
    @Inject private  var imageLoaderService:ImageLoaderServiceProtocol
    private var sub : AnyCancellable?
    weak var delegate:updateDelegate?
    var pageNo :Int = 0
    var photos:[Photo] =  [Photo]()
    
    
    init() {
        getSuggestionArray()
    }
    private  var suggestionList:Set<String> =  Set<String>()
    
    
     func getSuggestedList(searchString:String)->[String]{
        
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: searchString)
        let filtered = suggestionList.filter {
            $0.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        }
        return Array(filtered)
    }
    
    
    
    
    
    
    private func saveSearchData(){
        let defaults = UserDefaults.standard
        
        defaults.set(Array(suggestionList), forKey: "SaveSuggestionArray")
    }
    
    private func getSuggestionArray(){
        let defaults = UserDefaults.standard
        if let array = defaults.array(forKey: "SaveSuggestionArray")  as? [String]{
        suggestionList = Set(array)
        }
    }
    
    func getPhotos(searchString:String){
           pageNo =  1
           suggestionList.insert(searchString)
           saveSearchData()
        let photoList = photoService.fetchPhotoList(searchQueury: searchString, pageNo:"1")

           parseJsonModel(data: photoList) {[weak self] (data) in
                self?.photos =  data.hits
            
                self?.delegate?.didReceivedData()
               }
           }
       
       func loadMorePhotos(searchString:String){
           pageNo +=  1
            suggestionList.insert(searchString)
            saveSearchData()
          let photoList = photoService.fetchPhotoList(searchQueury: searchString, pageNo:"\(pageNo)")
           self.parseJsonModel(data: photoList) { [weak self](data) in
               self?.photos.append(contentsOf: data.hits)
               self?.delegate?.didReceivedData()
               }
       }
       
    func parseJsonModel<T:Codable>(data : AnyPublisher<T, Error>, callback :@escaping(T)->Void){
        sub =   data.sink(receiveCompletion: { (completionError) in
            switch completionError {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        }) { (data) in
            print(data)
            callback(data)
        }
    }
    
    func loadImage(for photo: Photo, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(photo.previewURL) }
            .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
                guard let poster = size == ImageSize.small ? photo.webformatURL  : photo.largeImageURL  , let url  =  URL(string: poster) else { return .just(nil) }
                return self.imageLoaderService.loadImage(from: url)
            })
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
}
