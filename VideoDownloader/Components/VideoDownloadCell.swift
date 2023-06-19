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
    var isYUVideo = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(viewModel:VideoFoundResponse){
        videoUrlLabel.text = viewModel.url
        isYUVideo = viewModel.isYoutubeVideo
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
        vc.urlString = videoUrlLabel.text ?? ""
        vc.isYoutubeVideo = isYUVideo
        uiNavigationController?.pushViewController(vc, animated: true)
    }
    
}
