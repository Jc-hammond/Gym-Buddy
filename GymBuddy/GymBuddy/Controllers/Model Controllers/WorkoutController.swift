//
//  WorkoutController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

class WorkoutController {
    
    //MARK: - Properties
    static let shared = WorkoutController()
    var workouts: [Workout] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Functions
    
    func addWorkout(title: String, goal: Int, unit: String, user: User, completion: @escaping (Result<Workout?, WorkoutError>) -> Void) {
        
        let userRef = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
        
        let newWorkout = Workout(title: title, goal: goal, completionDate: nil, unit: unit, userRef: userRef)
        
        user.workouts.append(newWorkout)
        
        let record = CKRecord(workout: newWorkout)
        
        publicDB.save(record) { record, error in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            guard let record = record else {return completion(.failure(.noRecord))}
            let workout = Workout(ckRecord: record)
            completion(.success(workout))
        }
    }
    
    func fetchWorkout(for user: User, completion: @escaping (Result<[Workout]?, WorkoutError>) -> Void) {
        let userRef = user.recordID
        let predicate = NSPredicate(format: "%K == %@", WorkoutStrings.userRefKey, userRef)
        let workoutIDs = user.workouts.compactMap({$0.recordID})
        //let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", workoutIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, /*predicate2*/])
        let query = CKQuery(recordType: "Workout", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else {return completion(.failure(.noRecord))}
            let workoutPoints = records.compactMap{ Workout(ckRecord: $0)}
            user.workouts = workoutPoints //.append(contentsOf: workoutPoints)
            completion(.success(workoutPoints))
        }
    }
    
    func updateWorkout(workout: Workout, completion: @escaping (Result<Workout?, WorkoutError>) -> Void) {
        
        let record = CKRecord(workout: workout)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _ , error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.nilRecord))}
            
            guard let workoutToUpdate = Workout(ckRecord: record) else {return completion(.failure(.nilRecord))}
            
            completion(.success(workoutToUpdate))
        }
        publicDB.add(operation)
    }
    
    func deleteWorkout(for workout: Workout, completion: @escaping (Result<Bool, WorkoutError>) -> Void) {
        let deleteOP = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [workout.recordID])
        deleteOP.savePolicy = .changedKeys
        deleteOP.qualityOfService = .userInteractive
        deleteOP.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            if records?.count == 0 {
                print("Deleted workout from CK")
                completion(.success(true))
            } else {
                return completion(.failure(.noRecord))
            }
        }
        publicDB.add(deleteOP)
    }
    
} //End of class
