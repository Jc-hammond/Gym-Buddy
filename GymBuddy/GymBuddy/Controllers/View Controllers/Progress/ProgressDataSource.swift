//
//  ProgressDataSource.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

struct Section: Hashable {
    let title: String
    //var items: [Item]?
}


struct Item: Hashable {

    let context: Context
    
    enum Context: Hashable {
        case progressRing(CGFloat)
        case weightHistory
        case list(Workout)
    }
}

struct Workout: Hashable {
    let title: String
    let goal: Int
    let completionDate: String?
    let current: Int
    let unit: String
}

//MARK: - Class
class ProgressDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    //MARK: - Temp Mock Data
    //JCHUN - Mock Data
    let mockWorkoutData: [Workout] = {
        var mockData = [Workout]()
        
        let running = Workout(title: "Running", goal: 3, completionDate: nil, current: 2, unit: "mi")
        let strengthTraining = Workout(title: "Strength Training", goal: 5, completionDate: nil, current: 4, unit: "hour")
        
        mockData = [running, strengthTraining]
        
        return mockData
    }()
    
    let mockCompletedWorkoutData: [Workout] = {
        var mockData = [Workout]()
        
        let running = Workout(title: "Running", goal: 3, completionDate: "6/25/21", current: 3, unit: "mi")
        let strengthTraining = Workout(title: "Strength Training", goal: 5, completionDate: "6/25/21", current: 5, unit: "hour")
        
        mockData = [running, strengthTraining]
        
        return mockData
    }()
    
    let mockSections: [Section] = {
        var sections = [Section]()
        
        let progressRing = Section(title: "  Overall Progress")
        let inProgress = Section(title: "  In Progress")
        let weightHistroy = Section(title: "  Weight History")
        let completed = Section(title: "  Completed")
        
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
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item.context {
            case .progressRing(let progress):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as? ProgressCollectionViewCell
                
                cell?.currentProgress = progress
                
                return cell
                
            case .weightHistory:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeightHistoryCollectionViewCell.id, for: indexPath) as? WeightHistoryCollectionViewCell
                
                //do I need cell.weightData = weightData ?
                
                return cell
                
            case .list(let workout):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.id, for: indexPath) as? ExerciseCollectionViewCell
                
                cell?.workout = workout
                
                return cell
            }
        }
        
        supplementaryViewProvider = { (collectionView: UICollectionView,
                                       kind: String,
                                       indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.id, for: indexPath) as? HeaderCollectionReusableView else { fatalError() }
            
            headerView.headerLabel.text = self.snapshot().sectionIdentifiers[indexPath.section].title
            
            return headerView
        }
        
        registerCells(for: collectionView)
        collectionView.collectionViewLayout = configureLayout()
        
    }//end of func
    
    //MARK: - Functions
    fileprivate func registerCells(for collectionView: UICollectionView) {
        collectionView.register(ProgressCollectionViewCell.nib, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        collectionView.register(WeightHistoryCollectionViewCell.nib, forCellWithReuseIdentifier: WeightHistoryCollectionViewCell.id)
        collectionView.register(ExerciseCollectionViewCell.nib, forCellWithReuseIdentifier: ExerciseCollectionViewCell.id)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: "header", withReuseIdentifier: HeaderCollectionReusableView.id)
    }
    
    func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // progress ring
        let progressRingItem = Item(context: .progressRing(0.9))
        
        // weight histroy graph
        let weightHistroyItem = Item(context: .weightHistory)
        
        // In Progress
        var workoutItems = [Item]()
        for workout in mockWorkoutData {
            let item = Item(context: .list(workout))
            workoutItems.append(item)
        }
        
        // Complted
        var completedItems = [Item]()
        for workout in mockCompletedWorkoutData {
            let item = Item(context: .list(workout))
            completedItems.append(item)
        }
        
        snapshot.appendSections(mockSections)
        
        snapshot.appendItems([progressRingItem], toSection: mockSections[0])
        snapshot.appendItems(workoutItems, toSection: mockSections[1])
        snapshot.appendItems([weightHistroyItem], toSection: mockSections[2])
        snapshot.appendItems(completedItems, toSection: mockSections[3])
        
        apply(snapshot)
        
    }//end of func
    
    fileprivate func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            var configuredSection: NSCollectionLayoutSection!
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.1))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            headerItem.pinToVisibleBounds = true
            
            switch sectionIndex {
            case 0:
                //Progress Ring
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(2/3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                configuredSection = section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.375))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: self.mockWorkoutData.count)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                configuredSection = section
                
            case 2:
                //Weight histroy graph
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                configuredSection = section
                
            case 3:
                //workout lists
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.375))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: self.mockWorkoutData.count)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                configuredSection = section

            default:
                fatalError("unexpected section found")
            }
            
            return configuredSection
        }
        
        return layout
    }
    
    
}//End of class

