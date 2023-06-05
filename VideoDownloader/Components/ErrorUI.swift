//
//  ErrorUi.swift
//  VideoDownloader
//
//  Created by mac on 4/6/2023.
//

import UIKit


class ErrorUI:UIView{
    
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        let view = Bundle.main.loadNibNamed("ErrorUI", owner: self,options: nil)![0] as! UIView
                view.frame = self.bounds
                self.addSubview(view)
    }
}
