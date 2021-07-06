//
//  User.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import UIKit
import CloudKit

struct UserStrings {
    
    static let recordType = "User"
     static let fullNameKey = "fullName"
     static let currentWeightsKey = "currentWeights"
     static let currentDatesKey = "currentDates"
     static let targetWeightKey = "targetWeight"
     static let friendsKey = "friends"
    fileprivate static let friendRefsKey = "friendRefs"
    fileprivate static let friendRequestsKey = "friendRequests"
    fileprivate static let friendRequestRefsKey = "friendRequestRefs"
    fileprivate static let goalDataKey = "goalData"
    fileprivate static let eventsKey = "events"
    static let appleUserRefKey = "appleUserRef"
    static let photoKey = "photo"
    
}


class User {
    
    var fullName: String
    var currentWeights: [Int]?
    var currentDates: [Date]?
    var targetWeight: Int
    var friends: [User]
    var friendRefs: [CKRecord.Reference]?
    var friendRequests: [FriendRequest]?
    var friendRequestRefs: [CKRecord.Reference]?
    var workouts: [Workout]
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    var photoData: Data?
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error writing to temporary URL \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage?, fullName: String, currentWeights: [Int]?, currentDates: [Date]?, targetWeight: Int, friends: [User] = [], friendRefs: [CKRecord.Reference]?, friendRequests: [FriendRequest]?, friendRequestRefs: [CKRecord.Reference]?, workouts: [Workout] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        
        self.fullName = fullName
        self.currentWeights = currentWeights
        self.currentDates = currentDates
        self.targetWeight = targetWeight
        self.friends = friends
        self.friendRefs = friendRefs
        self.friendRequests = friendRequests
        self.friendRequestRefs = friendRequestRefs
        self.workouts = workouts
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.photo = photo
    }
}


extension User {
    
    convenience init?(ckRecord: CKRecord){
        guard let fullName = ckRecord[UserStrings.fullNameKey] as? String,
              let currentWeights = ckRecord[UserStrings.currentWeightsKey] as? [Int],
              let currentDates = ckRecord[UserStrings.currentDatesKey] as? [Date],
              let targetWeight = ckRecord[UserStrings.targetWeightKey] as? Int,
              let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference
        else {return nil}
        
        let friendRefs = ckRecord[UserStrings.friendRefsKey] as? [CKRecord.Reference]
        let friendRequestRefs = ckRecord[UserStrings.friendRequestRefsKey] as? [CKRecord.Reference]
        var photo: UIImage?
        
        if let photoAsset = ckRecord[UserStrings.photoKey] as? CKAsset {
            do {
                guard let url = photoAsset.fileURL else {return nil}
                let data = try Data(contentsOf: url)
                photo = UIImage(data: data)
            } catch {
                print("Could not transfrom asset to data.")
            }
        }
        
        self.init(photo: photo, fullName: fullName, currentWeights: currentWeights, currentDates: currentDates, targetWeight: targetWeight, friends: [], friendRefs: friendRefs, friendRequests: nil, friendRequestRefs: friendRequestRefs, workouts: [], recordID: ckRecord.recordID, appleUserRef: appleUserRef)
    }
}

extension CKRecord {
    
    convenience init(user: User) {
        
        self.init(recordType: UserStrings.recordType, recordID: user.recordID)
        
        self.setValuesForKeys([
            UserStrings.fullNameKey : user.fullName,
            UserStrings.targetWeightKey : user.targetWeight,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
        
        if let friendRefs = user.friendRefs {
            self.setValue(friendRefs, forKey: UserStrings.friendRefsKey)
        }
        if let friendRequestRefs = user.friendRequestRefs {
            self.setValue(friendRequestRefs, forKey: UserStrings.friendRequestRefsKey)
        }
        if let currentWeights = user.currentWeights {
            self.setValue(currentWeights, forKey: UserStrings.currentWeightsKey)
        }
        if let currentDates = user.currentDates {
            self.setValue(currentDates, forKey: UserStrings.currentDatesKey)
        }
        if let photo = user.imageAsset {
            self.setValue(photo, forKey: UserStrings.photoKey)
        }
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

