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
    let uuid = UUID().uuidString
    
    let context: Context
    
    enum Context: Hashable {
        case progressRing(CGFloat)
        case weightHistory
        case list(Workout)
    }
}

extension Item {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


//MARK: - Class
class ProgressDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    
    //MARK: - Properties
    var inProgress = [Workout]()
    var completed = [Workout]()
    
    let sections: [Section] = {
        var sections = [Section]()
        
        let progressRing = Section(title: "  Overall Progress")
        let inProgress = Section(title: "  In Progress")
        let weightHistroy = Section(title: "  Weight History")
        let completed = Section(title: "  Completed")
        
        sections = [progressRing, inProgress, weightHistroy, completed]
        
        return sections
    }()
        
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
                
                let currentUser = UserController.shared.currentUser
                cell?.currentUser = currentUser
                
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
        
        guard let currentUser = UserController.shared.currentUser else { return }

        inProgress = []
        completed = []
        
        currentUser.workouts.forEach { workout in
            if workout.goal <= workout.current {
                completed.append(workout)
            } else {
                inProgress.append(workout)
            }
        }
        
        var totalGoal: CGFloat = 0
        var totalCurrent: CGFloat = 0
        
        // In Progress
        var inProgressItems = [Item]()
        for workout in inProgress {
            let item = Item(context: .list(workout))
            let caloriesBuffer: CGFloat = workout.unit == "calories" ? 0.1 : 1
            totalGoal += (CGFloat(workout.goal) * caloriesBuffer)
            totalCurrent += (CGFloat(workout.current) * caloriesBuffer)
            inProgressItems.append(item)
        }
        
        // progress ring
        let progress = totalCurrent == 0 ? 0 : totalCurrent/totalGoal
        let progressRingItem = Item(context: .progressRing(progress))
        
        // weight histroy graph
        let weightHistroyItem = Item(context: .weightHistory)
        
        
        // Complted
        var completedItems = [Item]()
        for workout in completed {
            let item = Item(context: .list(workout))
            completedItems.append(item)
        }
        
        snapshot.appendSections(self.sections)
        
        snapshot.appendItems([progressRingItem], toSection: self.sections[0])
        snapshot.appendItems(inProgressItems, toSection: self.sections[1])
        snapshot.appendItems([weightHistroyItem], toSection: self.sections[2])
        snapshot.appendItems(completedItems, toSection: self.sections[3])
        
        self.apply(snapshot, animatingDifferences: false)
        
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
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                //let count = self.inProgress.count == 0 ? 1 : self.inProgress.count
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
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
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                //let count = self.completed.count == 0 ? 1 : self.completed.count
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

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

