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
    var currentUser: User? {
        didSet {
            guard let weights = currentUser?.currentWeights,
                  let dates = currentUser?.currentDates else { return }
            
            currentWeights = weights
            currentDates = []
            dates.forEach { currentDates.append($0.formatDate()) }
            
            weightHistoryLineGraph()
        }
    }

    var currentWeights: [Int] = []
    var currentDates: [String] = []
    
    
    
    //MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        weightHistoryLineGraph()
    }
    
    //MARK: - Actions
    @IBAction func addWeightButtonTapped(_ sender: Any) {
        
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
            let date = Date().formatDate()
            self.currentDates.append(date)
            
            UserController.shared.currentUser?.currentWeights?.append(weight)
            UserController.shared.currentUser?.currentDates?.append(Date())
            
            UserController.shared.saveUserUpdates(currentUser: UserController.shared.currentUser!) { result in
                switch result {
                case .success(_):
                    print("Successfully updated currentUser's weight")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
            
            DispatchQueue.main.async {
                self.weightHistoryLineGraph()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        let tomorrowAlert = UIAlertController(title: "Come back tomorrow", message: "Today's weight was already added..", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        tomorrowAlert.addAction(okAction)
        
        if self.currentDates.contains(Date().formatDate()) {
            parentViewContoller?.present(tomorrowAlert, animated: true, completion: nil)
        } else {
            parentViewContoller?.present(alert, animated: true, completion: nil)
        }
    }//end of func
    
    
    //MARK: - Functions
    
    fileprivate func updateViews() {
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
