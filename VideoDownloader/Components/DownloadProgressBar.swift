//
//  DownloadProgressBar.swift
//  VideoDownloader
//
//  Created by mac on 5/6/2023.
//

import UIKit

class DownloadProgressBar:UIView{
    
    private let loadedShape = CAShapeLayer()
    private let remainShape = CAShapeLayer()
    @IBOutlet weak var progressLabel : UILabel!
    
    var lastValue = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    private func loadView(){
        let view = Bundle.main.loadNibNamed("DownloadProgressBar", owner: self,options: nil)![0] as! UIView
                view.frame = self.bounds
                self.addSubview(view)
        setup()
    }
    
    private func setup(){
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        loadedShape.path = circularPath.cgPath
        loadedShape.fillColor = UIColor.clear.cgColor
        loadedShape.strokeColor = UIColor(named: "secondary")?.cgColor
        loadedShape.lineWidth = 20
        loadedShape.strokeEnd = 0.0
        loadedShape.lineCap = .round
        progressLabel.text = "Totat\n 0%"
//        progressLabel.font = UIFont.systemFont(ofSize: 20)
        remainShape.path = circularPath.cgPath
        remainShape.fillColor = UIColor.clear.cgColor
        remainShape.strokeColor = UIColor(named: "accent")?.withAlphaComponent(0.8).cgColor
        remainShape.lineWidth = 20
        remainShape.lineCap = .round
        remainShape.shadowOpacity = 0.6
        remainShape.shadowColor = UIColor(named: "accent")?.cgColor
        self.layer.addSublayer(remainShape)
        self.layer.addSublayer(loadedShape)
        self.layer.addSublayer(loadedShape)
    }
    
    func updateProgress(percent: Float){
        loadedShape.strokeEnd = CGFloat(percent)
        progressLabel.text = "Totat\n \(String(format: "%.0f", percent*100))%"
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = lastValue
        strokeEndAnimation.toValue = percent
        strokeEndAnimation.duration = 1.0
        loadedShape.add(strokeEndAnimation, forKey: "strokeEndAnimation")
        lastValue = Double(percent)
    }
    
    func resetProgress(){
        loadedShape.strokeEnd = 0
        progressLabel.text = "Totat\n 0%"
        lastValue = 0
    }
    
}
