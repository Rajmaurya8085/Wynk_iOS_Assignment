//
//  PreviewViewController.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import UIKit
import Combine

class PreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var viewModel:PhotoListProtocol?
    var photo:Photo?
    private var cancellable: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel != nil && photo != nil {
        let image  =  viewModel!.loadImage(for: photo!, size: .original)
        setPhoto(posterImage: image)
        }
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setPhoto(posterImage:AnyPublisher<UIImage?, Never>){
          cancellable = posterImage.sink { [unowned self] image in self.showImage(image: image) }

       }
         private func showImage(image: UIImage?) {
           cancelImageLoading()
           UIView.transition(with: self.imageView,
           duration: 0.3,
           options: [.curveEaseOut, .transitionCrossDissolve],
           animations: {
            self.imageView.image = image
           })
       }

       
       private func cancelImageLoading() {
           imageView.image = nil
           cancellable?.cancel()
       }
    
}
