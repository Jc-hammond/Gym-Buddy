//
//  ProgressDataSource.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

struct Section: Hashable {
    let title: String
    //var items: [Item]
}


struct Item: Hashable {
    let context: Context
    
    enum Context: Hashable {
        case progressRing(UIView)
        case weightHistory(UIView)
        case list
    }
}

class ProgressDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    //MARK: - Temp Mock Data
    //JCHUN - Mock Data
    struct Workout: Hashable {
        let title: String
        let goal: Int
        let completionDate: String?
        let current: Int
        let unit: String
    }
    
    let mockWorkoutData: [Workout] = {
        var mockData = [Workout]()
        
        let running = Workout(title: "Running", goal: 3, completionDate: nil, current: 2, unit: "mi")
        let strengthTraining = Workout(title: "Strength Training", goal: 5, completionDate: "6/25/21", current: 5, unit: "hour")
        
        mockData = [running, strengthTraining]
        
        return mockData
    }()
    
    let mockSections: [Section] = {
        var sections = [Section]()
        
        let progressRing = Section(title: "Overall Progress")
        let inProgress = Section(title: "In Progress")
        let weightHistroy = Section(title: "Weight History")
        let completed = Section(title: "Completed")
        
        sections = [progressRing, inProgress, weightHistroy, completed]
        
        return sections
    }()
    
    //MARK: - Class Properties
//    private static var listHeaderCellConfiguration: UICollectionView.CellRegistration<UICollectionViewListCell, String> {
//        UICollectionView.CellRegistration { cell, indexPath, item in
//            var config = cell.defaultContentConfiguration()
//            config.text = item.capitalized //where does this string come from?
//            cell.contentConfiguration = config
//        }
//    }
//
//
//    private static var listItemCellConfiguration: UICollectionView.CellRegistration<UICollectionViewListCell, String> {
//        UICollectionView.CellRegistration { cell, indexPath, item in
//            var config = cell.defaultContentConfiguration()
//            config.text = item.capitalized
//            cell.contentConfiguration = config
//        }
//    }
    
    //MARK: - Init
//    init(collectionView: UICollectionView) {
//        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
//
//        }
//    }
    
    
}//End of class


