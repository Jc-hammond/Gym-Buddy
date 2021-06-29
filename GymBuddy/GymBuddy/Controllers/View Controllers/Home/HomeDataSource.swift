//
//  HomeDataSource.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

struct HomeItem: Hashable {
    
    let context: Context
    
    enum Context: Hashable {
        case friendList(String)
        case personalBest(Workout)
    }
}

class HomeDataSource: UICollectionViewDiffableDataSource<Section, HomeItem> {
    //MARK: - Temp Mock Data
    //JCHUN - Mock Data
    let mockFriends: [String] = [
        "Ben Tincher",
        "Connor Hammond",
        "Semisi Taufa",
        "Carson Ward",
        "James Chun"
    ]
    
    let mockCompletedWorkoutData: [Workout] = {
        var mockData = [Workout]()
        
        let running = Workout(title: "Running", goal: 3, completionDate: "6/25/21", current: 3, unit: "mi")
        let strengthTraining = Workout(title: "Strength Training", goal: 5, completionDate: "6/25/21", current: 5, unit: "hour")
        let basketball = Workout(title: "Basketball", goal: 5, completionDate: "6/25/21", current: 5, unit: "hour")
        let soccer = Workout(title: "Soccer", goal: 5, completionDate: "6/25/21", current: 5, unit: "hour")
        
        mockData = [running, strengthTraining, basketball, soccer]
        
        return mockData
    }()
    
    let mockSections: [Section] = {
        var sections = [Section]()
        
        let firendList = Section(title: "  Friends")
        let personalBest = Section(title: "  Personal Best")
        
        sections = [firendList, personalBest]
        
        return sections
    }()
    
    //MARK: - Init
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            
            switch homeItem.context {
            case .friendList(let name):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.id, for: indexPath) as? FriendCollectionViewCell
                cell?.friendName = name
                
                return cell
                
            case .personalBest(let workout):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalBestCollectionViewCell.id, for: indexPath) as? PersonalBestCollectionViewCell
                cell?.workout = workout
                
                return cell
            }
        }
        
        supplementaryViewProvider = { (collectionView: UICollectionView,
                                       kind: String,
                                       indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.id, for: indexPath) as? HeaderCollectionReusableView else { fatalError() }
            headerView.headerLabel.text = self.snapshot().sectionIdentifiers[indexPath.section].title
            
            if headerView.headerLabel.text == "  Friends" {
                headerView.isButtonHidden = false
            }
            
            return headerView
        }
        
        registerCells(for: collectionView)
        collectionView.collectionViewLayout = configureLayout()
    }//end of func
    
    fileprivate func registerCells(for collectionView: UICollectionView) {
        collectionView.register(FriendCollectionViewCell.nib, forCellWithReuseIdentifier: FriendCollectionViewCell.id)
        collectionView.register(PersonalBestCollectionViewCell.nib, forCellWithReuseIdentifier: PersonalBestCollectionViewCell.id)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: "header", withReuseIdentifier: HeaderCollectionReusableView.id)
    }
    
    func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HomeItem>()
        
        // Friends
        var friends = [HomeItem]()
        for friend in mockFriends {
            let item = HomeItem(context: .friendList(friend))
            friends.append(item)
        }
        
        // Personal Best
        var personalBestData = [HomeItem]()
        for workout in mockCompletedWorkoutData {
            let item = HomeItem(context: .personalBest(workout))
            personalBestData.append(item)
        }
        
        snapshot.appendSections(mockSections)
        
        snapshot.appendItems(friends, toSection: mockSections[0])
        snapshot.appendItems(personalBestData, toSection: mockSections[1])
        
        apply(snapshot)
    }
    
    fileprivate func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            var configuredSection: NSCollectionLayoutSection!
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.1))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            headerItem.pinToVisibleBounds = true
            
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 2, trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: self.mockFriends.count)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 4, leading: 10, bottom: 10, trailing: 10)
                
                configuredSection = section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                
                section.interGroupSpacing = 4
                section.contentInsets = .init(top: 4, leading: 10, bottom: 0, trailing: 10)
                
                configuredSection = section
                
            default:
                fatalError("Unexpected home section found")
            }
            return configuredSection
        }
        return layout
    }//end of func

}//End of class
