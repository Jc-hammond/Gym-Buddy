//
//  User.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

struct UserStrings {
    
    static let recordType = "User"
    fileprivate static let fullNameKey = "fullName"
    fileprivate static let currentWeightsKey = "currentWeights"
    fileprivate static let currentDatesKey = "currentDates"
    fileprivate static let targetWeightKey = "targetWeight"
    fileprivate static let friendsKey = "friends"
    fileprivate static let friendRefsKey = "friendRefs"
    fileprivate static let goalDataKey = "goalData"
    fileprivate static let eventsKey = "events"
    static let appleUserRefKey = "appleUserRef"
    
}


class User {
    
    var fullName: String
    var currentWeights: [Int]?
    var currentDates: [Date]?
    var targetWeight: Int
    var friends: [Friend]?
    var friendRefs: [CKRecord.Reference]?
    var workouts: [Workout]?
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    init(fullName: String, currentWeights: [Int]?, currentDates: [Date]?, targetWeight: Int, friends: [Friend]?, friendRefs: [CKRecord.Reference]?, workouts: [Workout]?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        
        self.fullName = fullName
        self.currentWeights = currentWeights
        self.currentDates = currentDates
        self.targetWeight = targetWeight
        self.friends = friends
        self.friendRefs = friendRefs
        self.workouts = workouts
        self.recordID = recordID
        self.appleUserRef = appleUserRef
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
        
        
        self.init(fullName: fullName, currentWeights: currentWeights, currentDates: currentDates, targetWeight: targetWeight, friends: nil, friendRefs: friendRefs, workouts: nil, recordID: ckRecord.recordID, appleUserRef: appleUserRef)
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
        if let currentWeights = user.currentWeights {
            self.setValue(currentWeights, forKey: UserStrings.currentWeightsKey)
        }
        if let currentDates = user.currentDates {
            self.setValue(currentDates, forKey: UserStrings.currentDatesKey)
        }
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
