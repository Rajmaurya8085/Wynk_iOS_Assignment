//
//  PhotoListViewController.swift
//  Wynk_iOS_Assignment
//
//  Created by Raj Maurya on 11/06/20.
//  Copyright © 2020 Xebia. All rights reserved.
//

import UIKit
import Combine

class PhotoListViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var suggestionTableView: UITableView!
    
    var suggestionList:[String] = [String]()
    var viewModel: PhotoListProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = PhotoListViewModel()
        viewModel.delegate = self
        viewModel.getPhotos(searchString: "")
    }
    
    
  private lazy var searchController: UISearchController = {
         let searchController = UISearchController(searchResultsController: nil)
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.tintColor = UIColor.black
         searchController.searchBar.delegate = self
         return searchController
     }()

    
    private func configureUI() {
           definesPresentationContext = true
           title = NSLocalizedString("Photo", comment: "Photo")
           navigationItem.searchController = self.searchController
           navigationItem.hidesSearchBarWhenScrolling = false
           searchController.isActive = true
       }

}


extension PhotoListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView  ==  suggestionTableView{
            return suggestionList.count
        }
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  tableView  == suggestionTableView{
            let cellid = "cell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
            }
            cell?.textLabel?.text = suggestionList[indexPath.row]
            return cell!
        }else{
        let photoCell  =  tableView.dequeueReusableCell(withIdentifier: "PhotoListTableCell", for: indexPath) as? PhotoListTableCell
        
        photoCell?.selectionStyle = .none
        let image  =  viewModel.loadImage(for: viewModel.photos[indexPath.row], size: .small)
        photoCell?.setPhoto(posterImage: image)
        
        if viewModel.photos.count - 2 ==  indexPath.row {
            viewModel.loadMorePhotos(searchString:searchController.searchBar.text ?? "")
        }
        return photoCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionTableView{
            viewModel.getPhotos(searchString: suggestionList[indexPath.row])
            suggestionTableView.isHidden =  true
        }else{
            let controller  =   UIStoryboard.loadViewController(storyBoardName:"Main", identifierVC: "PreviewViewController", type: PreviewViewController.self)
            controller.viewModel = self.viewModel
            controller.photo =  viewModel.photos[indexPath.row]
            self.navigationController?.present(controller, animated: true, completion:nil)
        }
    
     tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension PhotoListViewController:updateDelegate{
    func didReceivedData() {
        tableView.reloadData()
    }
}


extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       suggestionList  =   viewModel.getSuggestedList(searchString: searchText)
       suggestionTableView.reloadData()
        if suggestionList.count == 0{
        suggestionTableView.isHidden =  true
        }else{
        suggestionTableView.isHidden =  false
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     //  viewModel.getPhotos(searchString: searchBar.text ?? "")
        suggestionTableView.isHidden =  true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getPhotos(searchString: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let newText = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        
        return true
    }
}





class PhotoListTableCell:UITableViewCell{
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    private var cancellable: AnyCancellable?
    override func awakeFromNib() {
        
    }
    
    func setPhoto(posterImage:AnyPublisher<UIImage?, Never>){
          cancellable = posterImage.sink { [unowned self] image in self.showImage(image: image) }

       }
         private func showImage(image: UIImage?) {
           cancelImageLoading()
           UIView.transition(with: self.photoImageView,
           duration: 0.3,
           options: [.curveEaseOut, .transitionCrossDissolve],
           animations: {
               self.photoImageView.image = image
           })
       }

       
       private func cancelImageLoading() {
           photoImageView.image = nil
           cancellable?.cancel()
       }
    
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
}
