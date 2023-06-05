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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(viewModel:VideoFoundResponse){
        videoUrlLabel.text = viewModel.url
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        print("do something ... ")
    }
    
}
