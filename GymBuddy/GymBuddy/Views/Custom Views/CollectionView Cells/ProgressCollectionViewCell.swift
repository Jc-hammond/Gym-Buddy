//
//  ProgressCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit
import Charts

class ProgressCollectionViewCell: UICollectionViewCell, CellRegisterable {
    
    //MARK: - Properties
    lazy var currentProgress: CGFloat? = 0.0 {
        didSet {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.progressRing()
            }
        }
    }
    
        
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        
        return label
    }()
                
    //MARK: - Functions
    func progressRing() {
        guard let currentProgress = currentProgress else { return }
        contentView.backgroundColor = .clear
        
        label.sizeToFit()
        contentView.addSubview(label)
        label.center = contentView.center
        label.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        label.textColor = .customDarkGreen
        
        label.text = "\(Int(currentProgress * 100))%"
        
        //start angle of each circle
        let startAngle = -CGFloat.pi / 2
        
        // Draw a circle
        let center = contentView.center
        
        /// create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        contentView.layer.addSublayer(trackLayer)
        
        trackLayer.anchorPoint = center
        
        
        ///create progress layer
        let shapeLayer = CAShapeLayer()

        let progressPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: startAngle + (2 * CGFloat.pi * currentProgress), clockwise: true)
        shapeLayer.path = progressPath.cgPath
        
        shapeLayer.strokeColor = UIColor.customLightGreen?.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        contentView.layer.addSublayer(shapeLayer)

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        
    }//end of func
    
}//End of class


