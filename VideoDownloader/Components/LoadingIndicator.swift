//
//  LoadingIndicator.swift
//  VideoDownloader
//
//  Created by mac on 4/6/2023.
//

import UIKit

class LoadingIndicator:UIView{
    
    private let loadingShape = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        loadingShape.path = circularPath.cgPath
        loadingShape.fillColor = UIColor.clear.cgColor
        loadingShape.strokeColor = UIColor(named: "primary")?.cgColor
        loadingShape.lineWidth = 5
        loadingShape.strokeEnd = 0.3
        loadingShape.lineCap = .round
        self.layer.addSublayer(loadingShape)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2*Double.pi
        animation.duration = 2.0
        animation.repeatCount = .infinity
        self.layer.add(animation, forKey: "rotationAnimation")
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 3.0
        strokeEndAnimation.repeatCount = .infinity
        loadingShape.add(strokeEndAnimation, forKey: "strokeEndAnimation")
    }
    
    
}
