//
//  WeightHistoryCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/28/21.
//

import UIKit
import Charts

class WeightHistoryCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var addWeightButton: UIButton!
    @IBOutlet weak var graphView: UIView!
    
    //MARK: - Properties
    let lineChart = LineChartView()

    ///Mock Data
    var currentWeights: [Int] = [
        180,
        185,
        187,
        190,
        192,
        190,
        194,
        189,
        190,
        188
    ] {
        didSet{
            weightHistoryLineGraph()
        }
    }
    
    var currentDates: [String] = [
        "6/1/21",
        "6/2/21",
        "6/3/21",
        "6/4/21",
        "6/5/21",
        "6/6/21",
        "6/7/21",
        "6/8/21",
        "6/9/21",
        "6/10/21"
    ]
    
    
    
    //MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
////        updateViews()
////        weightHistoryLineGraph()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        //fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        weightHistoryLineGraph()
    }
    
    //MARK: - Actions
    @IBAction func addWeightButtonTapped(_ sender: Any) {
        
        //JCHUN - add alertcontroller and add weight
        let alert = UIAlertController(title: "Add Weight", message: "Add today's weight below", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let input = alert.textFields?.first?.text,
                  !input.isEmpty,
                  let weight = Int(input) else { return }
            
            self.lineChart.data = nil
            self.currentWeights.append(weight)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        parentViewContoller?.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Functions
    
    fileprivate func updateViews() {
//        contentView.backgroundColor = .gray
//        graphView.backgroundColor = .blue
        
        addWeightButton.addCornerRadius()
        addWeightButton.setBackgroundColor((.customLightGreen ?? .green))
        addWeightButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 14)
        addWeightButton.setTitleColor(.white, for: .normal)
        addWeightButton.setTitle("add today's weight", for: .normal)
        
    }//end of func
    
    func weightHistoryLineGraph() {
        
        //set frame
        lineChart.frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.width)
        lineChart.center = self.graphView.center
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelTextColor = .customLightGreen!
        lineChart.xAxis.labelFont = UIFont(name: FontNames.sfRoundedSemiBold, size: 12)!
        lineChart.xAxis.axisLineColor = .customLightGreen!
        lineChart.xAxis.setLabelCount(currentWeights.count - 1, force: false)
        
        lineChart.leftAxis.labelTextColor = .customLightGreen!
        lineChart.leftAxis.labelFont = UIFont(name: FontNames.sfRoundedSemiBold, size: 12)!
        lineChart.leftAxis.axisLineColor = .customLightGreen!
        
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        
        lineChart.animate(xAxisDuration: 1.0)
        
        //add to view
        graphView.addSubview(lineChart)
        
        //constrain
        lineChart.anchor(
            top: graphView.topAnchor,
            bottom: graphView.bottomAnchor,
            leading: graphView.leadingAnchor,
            trailing: graphView.trailingAnchor,
            paddingTop: 0,
            paddingBottom: 0,
            paddingLeading: 0,
            paddingTrailing: 0,
            width: graphView.frame.width,
            height: graphView.frame.height
        )
        
        //add data
        //JCHUN - need actual data
        var entries = [ChartDataEntry]()
        
        for x in 0..<currentWeights.count {
            entries.append(ChartDataEntry(x: Double(x), y: Double(currentWeights[x])))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
}//End of class
