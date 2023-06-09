//
//  HomeViewController.swift
//  VideoDownloader
//
//  Created by mac on 3/6/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableResult: UITableView!
    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    @IBOutlet weak var errorResult: ErrorUI!
    @IBOutlet weak var noDataFoundResult: NoVideoFoundUI!
    
    
    // MARK: Properties
    var presenter = Presenter()
    var videos = [VideoFoundResponse]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableResult.dataSource = self
        searchTableResult.register(UINib(nibName: "VideoDownloadCell", bundle: nil), forCellReuseIdentifier: VideoDownloadCell.identifier)
        searchTableResult.rowHeight = 70
    }

    @IBAction func searchAction(_ sender: Any) {
        Task { @MainActor in
            loadingIndicator.isHidden = false
            searchTableResult.isHidden = true
            errorResult.isHidden = true
            noDataFoundResult.isHidden = true
            guard let urlString = searchTextField.text, let _ = URL(string: urlString) else{
                errorResult.isHidden = false
                print("url string not valid")
                return
            }
            do{
                videos = try await presenter.fetchFoundVideo(params: SearchFormViewModel(url:urlString ))
                if videos.count == 0 {
                    noDataFoundResult.isHidden = false
                } else {
                    searchTableResult.isHidden = false
                }
                searchTableResult.reloadData()
                
            }catch{
                errorResult.isHidden = false
            }
            loadingIndicator.isHidden = true
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableResult.dequeueReusableCell(withIdentifier: VideoDownloadCell.identifier, for: indexPath) as! VideoDownloadCell
        cell.uiNavigationController = self.navigationController
        cell.update(viewModel: videos[indexPath.row])
        return cell
    }
    
    
}
