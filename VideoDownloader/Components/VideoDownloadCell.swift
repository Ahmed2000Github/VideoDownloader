//
//  VideoDownloadCell.swift
//  VideoDownloader
//
//  Created by mac on 4/6/2023.
//

import UIKit

class VideoDownloadCell: UITableViewCell {
    
    static let identifier = "VideoDownloadCellID"

    @IBOutlet weak var videoUrlLabel: UILabel!
    
    var uiNavigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(viewModel:VideoFoundResponse){
        videoUrlLabel.text = viewModel.url
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
        vc.urlString = videoUrlLabel.text ?? ""
        uiNavigationController?.pushViewController(vc, animated: true)
    }
    
}
