//
//  QualityFormatCell.swift
//  VideoDownloader
//
//  Created by mac on 7/6/2023.
//

import UIKit

class QualityFormatCell: UITableViewCell {
    static let identifier = "QualityFormatCellID"

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func update(qualityLabel:String){
        label.text = qualityLabel
    }
    
}
