//
//  ProgressDataSource.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

struct Section: Hashable {
    let title: String
    var items: [Item]
}

struct Workout: Hashable {
    let title: String
    let goal: Int
    let current: Int
}

struct Item: Hashable {
    let context: Context
    
    enum Context: Hashable {
        case progressRing(UIView)
        case weightHistory(UIView)
        case list(Workout)
    }
}

class ProgressDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    
    
    
}//End of class


