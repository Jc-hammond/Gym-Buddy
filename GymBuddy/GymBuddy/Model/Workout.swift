//
//  Workout.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

struct WorkoutStrings {
    
    static let recordType = "Workout"
    static let titleKey = "title"
    static let goalKey = "goal"
    static let completionDateKey = "completionDate"
    static let currentKey = "current"
    static let unitKey = "unit"
    static let userRefKey = "userRef"
}

struct Workout: Hashable {
    
    let title: String
    var goal: Int
    let completionDate: String?
    var current: Int
    let unit: String
    var userRef: CKRecord.Reference?
    let recordID: CKRecord.ID
    
    init(title: String, goal: Int, completionDate: String?, current: Int = 0, unit: String, userRef: CKRecord.Reference?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.goal = goal
        self.completionDate = completionDate
        self.current = current
        self.unit = unit
        self.userRef = userRef
        self.recordID = recordID
    }
    
}


extension Workout {
    
    //convenience?
     init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[WorkoutStrings.titleKey] as? String,
              let goal = ckRecord[WorkoutStrings.goalKey] as? Int,
              let current = ckRecord[WorkoutStrings.currentKey] as? Int,
              let unit = ckRecord[WorkoutStrings.unitKey] as? String else {return nil}
        
        let userRef = ckRecord[WorkoutStrings.userRefKey] as? CKRecord.Reference
        let completionDate = ckRecord[WorkoutStrings.completionDateKey] as? String
        
        self.init(title: title, goal: goal, completionDate: completionDate, current: current, unit: unit, userRef: userRef, recordID: ckRecord.recordID)
    }
    
}

extension CKRecord {
    
    convenience init(workout: Workout) {
        
        self.init(recordType: WorkoutStrings.recordType, recordID: workout.recordID)
        
        self.setValuesForKeys([
            WorkoutStrings.titleKey : workout.title,
            WorkoutStrings.goalKey : workout.goal,
            WorkoutStrings.currentKey : workout.current,
            WorkoutStrings.unitKey : workout.unit
        ])
        
        if let userRef = workout.userRef {
            self.setValue(userRef, forKey: WorkoutStrings.userRefKey)
        }
        if let completionDate = workout.completionDate {
            self.setValue(completionDate, forKey: WorkoutStrings.completionDateKey)
        }
    }
}


extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}


