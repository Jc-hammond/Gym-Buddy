//
//  ProgressCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var view: UIView!
    
    //MARK: - Properties
    //JCHUN - need a landing pad to for CollectionView Item Type...
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        //JCHUN - assgin overall % completion
        label.text = ""
        label.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        
        return label
    }()
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func addCustomObjects() {
        //JCHUN - if Item Type isprogressRing call progressRing(), if it is weightHistroy call weightHistroy
    }
    
    fileprivate func progressRing() {
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
        
        // Draw a circle
        let center = view.center
        
        //create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        
        
        //create progress layer
        let shapeLayer = CAShapeLayer()

        let progressPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
        shapeLayer.path = progressPath.cgPath
        
        shapeLayer.strokeColor = UIColor.customLightGreen?.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        
    }//end of func
    
    

}//End of class


