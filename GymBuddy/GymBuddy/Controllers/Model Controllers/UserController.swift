//
//  UserController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

class UserController {
    
    //MARK: - Properties
    static var shared = UserController()
    let publicDB = CKContainer.default().publicCloudDatabase
    var currentUser: User? {
        didSet {
            if let currentUserID = currentUser?.recordID {
            currentUserRef = CKRecord.Reference(recordID: currentUserID, action: .none)
            }
        }
    }
    var currentUserRef: CKRecord.Reference?
    var users: [User] = []
    
    
    //MARK: - Functions
    func createUser(fullName: String, currentWeight: Int, targetWeight: Int, completion: @escaping (Result<User?, UserError>) -> Void) {
        fetchAppleUserReference { result in
            switch result {
            case .success(let reference):
                guard let reference = reference else {return completion(.failure(.noAppleUser))}
                let date = Date()
                let user = User(fullName: fullName, currentWeights: [currentWeight], currentDates: [date], targetWeight: targetWeight, friends: [], friendRefs: nil, friendRequests: nil, friendRequestRefs: nil, workouts: [], appleUserRef: reference)
                let record = CKRecord(user: user)
                
                self.publicDB.save(record) { record, error in
                    if let error = error {
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = record,
                          let user = User(ckRecord: record) else {return completion(.failure(.noProfile))}
                    
                    self.users.append(user)
                    completion(.success(user))
                }
            case .failure(.noAppleUser):
                print("No reference to an apple iCloud account was found")
            default:
                print("Shouldn't happen")
            }
        }
    }
    
    func deleteUser(for user: User, completion: @escaping (Result<Bool, UserError>) -> Void) {
        let deleteOp = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [user.recordID])
        deleteOp.savePolicy = .changedKeys
        deleteOp.qualityOfService = .userInteractive
        deleteOp.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            if records?.count == 0 {
                print("Deleted Profile from CK")
                completion(.success(true))
            } else {
                return completion(.failure(.noRecord))
            }
        }
        publicDB.add(deleteOp)
    }
    
    func fetchProfile(predicate: NSPredicate, completion: @escaping (Result<[User]?, UserError>) -> Void) {
        
        let profQuery = CKQuery(recordType: UserStrings.recordType, predicate: predicate)
        
        self.publicDB.perform(profQuery, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.nilRecord))}
            
            let users = records.compactMap({ User(ckRecord: $0)})
            
            if !users.isEmpty {
                completion(.success(users))
            } else {
                completion(.failure(.nilRecord))
            }
        }
    }
    
    func fetchAppleUserReference(completion: @escaping (Result<CKRecord.Reference?, UserError>) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                completion(.success(reference))
            }
        }
    }
    
    func saveUserUpdates(currentUser: User, completion: @escaping (Result<User?, UserError>) -> Void) {
      
        let record = CKRecord(user: currentUser)
        
        let operation = CKModifyRecordsOperation(
            recordsToSave: [record],
            recordIDsToDelete: nil
        )
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.nilRecord))}
            
            guard let userToUpdate = User(ckRecord: record) else {return completion(.failure(.nilRecord))}
            print("Update \(record.recordID) in Cloudkit")
            
            completion(.success(userToUpdate))
        }
        publicDB.add(operation)
    }
    
}
