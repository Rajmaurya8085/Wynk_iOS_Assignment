//
//  Wynk_iOS_AssignmentTests.swift
//  Wynk_iOS_AssignmentTests
//
//  Created by Raj on 05/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import XCTest
@testable import Wynk_iOS_Assignment

class Wynk_iOS_AssignmentTests: XCTestCase {

  lazy var service =  PhotoService()
     lazy var viewModel = PhotoListViewModel()
     lazy var dummyModel = Photo(id: 400734, pageURL: "https://pixabay.com/photos/dhonis-full-moon-island-maldives-400734/", type: "photo", tags: "dhonis, full moon island, maldives", previewURL: "https://cdn.pixabay.com/photo/2014/07/24/04/02/dhonis-400734_150.jpg", previewWidth: 150, previewHeight: 99, largeImageURL: "https://pixabay.com/get/52e0d5444956b108f5d0846096293177153fdced5b4c704c7c2e72d79f48c65f_1280.jpg", webformatURL: "https://pixabay.com/get/52e0d5444956b10ff3d8992cc62e3e7e153dd6ed4e507440742678dc924ec2_640.jpg", imageWidth: 3216, imageHeight: 2136, views: 1474, favorites: 0, downloads: 601, likes: 3, comments: 0, user_id: 351382, user: "wangchaonan", userImageURL: "")
     
   
    
   
 //      lazy var imageLoader: ImageLoaderServiceType = {
 //          let mock = ImageLoaderServiceTypeMock()
 //          mock.loadImageFromClosure = { _ in
 //              let image = UIImage(named: "joker.jpg", in: Bundle(for: EarlGrey.self), compatibleWith: nil)
 //              return .just(image)
 //          }
 //          return mock
 //      }()
     
     
     func testPhotoRequestUrl() {
         let urlRequest = service.makeNowplayingURlComponents(searchString: "", pageNo: "1")
      
        XCTAssert(urlRequest.url?.scheme ==  "https", "Url Request Schema Wrong")
        XCTAssert(urlRequest.url?.path ==  "/api", "Url Request path Wrong")
        XCTAssert(urlRequest.url?.host ==  "pixabay.com", "Url Request host Wrong")
         
     }
     
    

     
     func testPhotoApiCall(){
         let paynow =  service.fetchPhotoList(searchQueury: "india", pageNo: "1")
        let expectation = XCTestExpectation(description: "Download photo home page")
         
         let data  =  paynow.sink(receiveCompletion: { (completionError) in
         switch completionError {
         case .failure( _):
                 XCTAssertNil(completionError, " error during fetching Now photo data .")
                   case .finished:
                      expectation.fulfill()
                       break
                   }
                }) { (data) in
                 print(data)
                 XCTAssertNotNil(data, "No  not able to fetch Photos .")
                 expectation.fulfill()
                }
         
         wait(for: [expectation], timeout: 10.0)
              
     }


       
     
     func testImageDownload(){
         let expectation = XCTestExpectation(description: "Download image home page"
             )
             let posterImage  =  viewModel.loadImage(for: dummyModel, size:.small)
               .sink {  image in
              XCTAssertNotNil(image, "No  not able to fetch Photo .")
              expectation.fulfill()

            }
       wait(for: [expectation], timeout: 15.0)
         }
     
     

  

}
