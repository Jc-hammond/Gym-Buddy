//
//  ProgressCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit
import Charts

class ProgressCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var view: UIView!
    
    //MARK: - Properties
    //JCHUN - need a general landing pad to for CollectionView Item Type...
    
    var currentProgress: CGFloat = 0.9 {
        didSet {
            didProgressUpdate()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        
        return label
    }()
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func addCustomObjects() {
        //JCHUN - if Item Type isprogressRing call progressRing(), if it is weightHistroy call weightHistoryLineGraph
    }
    
    fileprivate func progressRing() {
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
        
        //start angle of each circle
        let startAngle = -CGFloat.pi / 2
        
        // Draw a circle
        let center = view.center
        
        //create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        
        
        //create progress layer
        let shapeLayer = CAShapeLayer()

        let progressPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: startAngle + (2 * CGFloat.pi * currentProgress), clockwise: true)
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
    
    fileprivate func didProgressUpdate() {
        label.text = "\(Int(currentProgress * 100))%"
    }
    
    fileprivate func weightHistoryLineGraph() {
        let lineChart = LineChartView()
        
        //set frame
        lineChart.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        lineChart.center = self.view.center
        
        //add to view
        view.addSubview(lineChart)
        
        //add data
        //JCHUN - need actual data
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
    override func prepareForReuse() {
        view = nil
    }

}//End of class


