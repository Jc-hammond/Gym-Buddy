//
//  HomeDataSource.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

struct HomeItem {
    let uuid = UUID()
    
    let context: Context
    
    enum Context: Hashable {
        //case friendList(String)
        case weight
        case personalBest(Workout)
    }
}

extension HomeItem : Hashable {
    static func == (lhs: HomeItem, rhs: HomeItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


class HomeDataSource: UICollectionViewDiffableDataSource<Section, HomeItem> {
    //MARK: - Temp Mock Data
    //JCHUN - Mock Data
//    let mockFriends: [String] = [
//        "Tyrion Lannister",
//        "Arya Stark",
//        "Jon Snow",
//        "Daenerys Targaryen",
//        "Tormund Giantsbane"
//    ]
        
    var personalBests = [Workout]()
    
    let sections: [Section] = {
        var sections = [Section]()
        
        let weightList = Section(title: "  Weight Summary")
        let personalBest = Section(title: "  Personal Best")
        
        sections = [weightList, personalBest]
        
        return sections
    }()
    
    //MARK: - Init
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            
            switch homeItem.context {
            case .weight:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeightCollectionViewCell.id, for: indexPath) as? WeightCollectionViewCell
                
                cell?.currentUser = UserController.shared.currentUser
                cell?.itemNumber = indexPath.row
                
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
            
            headerView.sectionNumber = indexPath.section
                        
            return headerView
        }
        
        registerCells(for: collectionView)
        collectionView.collectionViewLayout = configureLayout()
    }//end of func
    
    fileprivate func registerCells(for collectionView: UICollectionView) {
        //collectionView.register(FriendCollectionViewCell.nib, forCellWithReuseIdentifier: FriendCollectionViewCell.id)
        collectionView.register(WeightCollectionViewCell.nib, forCellWithReuseIdentifier: WeightCollectionViewCell.id)
        collectionView.register(PersonalBestCollectionViewCell.nib, forCellWithReuseIdentifier: PersonalBestCollectionViewCell.id)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: "header", withReuseIdentifier: HeaderCollectionReusableView.id)
    }
    
    func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HomeItem>()
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        personalBests = []
        currentUser.workouts.forEach { workout in
            if workout.goal <= workout.current {
                personalBests.append(workout)
            }
        }
        
        personalBests = personalBests.sorted { $0.title < $1.title }
        
        var removalIndex = [Int]()
        for i in 0..<personalBests.count - 1 {
            if personalBests[i].title == personalBests[i+1].title {
                if personalBests[i].goal < personalBests[i+1].goal {
                    removalIndex.append(i)
                } else {
                    removalIndex.append(i+1)
                }
            }
        }
        
        removalIndex.reverse()
        
        for i in 0..<removalIndex.count {
            personalBests.remove(at: removalIndex[i])
        }
        
        // Friends
//        var friends = [HomeItem]()
//        for friend in mockFriends {
//            let item = HomeItem(context: .friendList(friend))
//            friends.append(item)
//        }
        
        //Weight Items
        var weightItem = [HomeItem]()
        for _ in 0...1 {
            let item = HomeItem(context: .weight)
            weightItem.append(item)
        }
        
        // Personal Best
        var personalBestData = [HomeItem]()
        for best in personalBests {
            let item = HomeItem(context: .personalBest(best))
            personalBestData.append(item)
        }
        
        snapshot.appendSections(sections)
        
        snapshot.appendItems(weightItem, toSection: sections[0])
        snapshot.appendItems(personalBestData, toSection: sections[1])
        
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
                item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 4, bottom: 2, trailing: 4)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.75))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 0, trailing: 4)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.orthogonalScrollingBehavior = .none
                
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
