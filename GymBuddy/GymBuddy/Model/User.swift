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
    fileprivate static let hoursWorkedOutKey = "hoursWorkedOut"
    fileprivate static let currentDatesKey = "currentDates"
    fileprivate static let targetHoursKey = "targetHours"
    fileprivate static let friendsKey = "friends"
    fileprivate static let friendRefsKey = "friendRefs"
    fileprivate static let friendRequestsKey = "friendRequests"
    fileprivate static let friendRequestRefsKey = "friendRequestRefs"
    fileprivate static let goalDataKey = "goalData"
    fileprivate static let eventsKey = "events"
    static let appleUserRefKey = "appleUserRef"
    static let blockedUserRefsKey = "blockedUserRefs"
    
}


class User {
    
    var fullName: String
    var hoursWorkedOut: [Int]?
    var currentDates: [Date]?
    var targetHours: Int
    var blockedUserRefs: [CKRecord.Reference]?
    var workouts: [Workout]
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    init(fullName: String, hoursWorkedOut: [Int]? , currentDates: [Date]?, targetHours: Int, blockedUserRefs: [CKRecord.Reference]?, workouts: [Workout] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        
        self.fullName = fullName
        self.hoursWorkedOut = hoursWorkedOut
        self.currentDates = currentDates
        self.targetHours = targetHours
        self.blockedUserRefs = blockedUserRefs
        self.workouts = workouts
        self.recordID = recordID
        self.appleUserRef = appleUserRef
    }
}


extension User {
    
    convenience init?(ckRecord: CKRecord){
        guard let fullName = ckRecord[UserStrings.fullNameKey] as? String,
              let hoursWorkedOut = ckRecord[UserStrings.hoursWorkedOutKey] as? [Int],
              let currentDates = ckRecord[UserStrings.currentDatesKey] as? [Date],
              let targetHours = ckRecord[UserStrings.targetHoursKey] as? Int,
              let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference
        else {return nil}
        
        let blockedUserRefs = ckRecord[UserStrings.blockedUserRefsKey] as? [CKRecord.Reference]
        
        self.init(fullName: fullName, hoursWorkedOut: hoursWorkedOut, currentDates: currentDates, targetHours: targetHours, blockedUserRefs: blockedUserRefs, workouts: [], recordID: ckRecord.recordID, appleUserRef: appleUserRef)
    }
}

extension CKRecord {
    
    convenience init(user: User) {
        
        self.init(recordType: UserStrings.recordType, recordID: user.recordID)
        
        self.setValuesForKeys([
            UserStrings.fullNameKey : user.fullName,
            UserStrings.targetHoursKey : user.targetHours,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
        
        if let hoursWorkedOut = user.hoursWorkedOut {
            self.setValue(hoursWorkedOut, forKey: UserStrings.hoursWorkedOutKey)
        }
        if let currentDates = user.currentDates {
            self.setValue(currentDates, forKey: UserStrings.currentDatesKey)
        }
        if let blockedUserRefs = user.blockedUserRefs {
            self.setValue(blockedUserRefs, forKey: UserStrings.blockedUserRefsKey)
        }
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
