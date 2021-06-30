//
//  FriendController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

class FriendController {
    
    //MARK: - Properties
    static let shared = FriendController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func createFriendRequest(friendUser: User, completion: @escaping (Result<[Friend]?, FriendError>) -> Void){
        
        guard let currentUser = UserController.shared.currentUser else {return completion(.failure(.noCurrentUser))}
        let ownerRef = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        let friendRef = CKRecord.Reference(recordID: friendUser.recordID, action: .deleteSelf)
        let ownerRequest = Friend(ownerUserRef: ownerRef, friendUserRef: friendRef, friendName: friendUser.fullName, ownerDidSend: true, accepted: false, siblingRef: nil)
        let ownerReqRef = CKRecord.Reference(recordID: ownerRequest.recordID, action: .deleteSelf)
        
        let friendRequest = Friend(ownerUserRef: friendRef, friendUserRef: ownerRef, friendName: currentUser.fullName, ownerDidSend: false, accepted: false, siblingRef: ownerReqRef)
        let friendReqRef = CKRecord.Reference(recordID: friendRequest.recordID, action: .deleteSelf)
        
        ownerRequest.siblingRef = friendReqRef
        
        let ownerRecord = CKRecord(friend: ownerRequest)
        let friendRecord = CKRecord(friend: friendRequest)
        var requests: [Friend] = []
        
        publicDB.save(ownerRecord) { record, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let friend = Friend(ckRecord: record) else {return completion(.failure(.nilRecord))}
            requests.append(friend)
        }
        publicDB.save(friendRecord) { record, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let friend = Friend(ckRecord: record) else {return completion(.failure(.nilRecord))}
            requests.append(friend)
        }
        completion(.success(requests))
        
    }
    
    func fetchRequestsForProfile(predicate: NSPredicate, completion: @escaping (Result<[Friend]?, FriendError>) -> Void) {
        
        let friendQuery = CKQuery(recordType: FriendConstants.recordType, predicate: predicate)
        
        publicDB.perform(friendQuery, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.nilRecord))}
            let friends = records.compactMap({ Friend(ckRecord: $0 )})
            completion(.success(friends))
        }
    }
    
    func toggleFriendAcceptance(response: Bool, request: Friend, completion: @escaping (Result<[Friend]?, FriendError>) -> Void) {
        
        switch response {
        case true:
            guard !request.ownerDidSend else {return}
            request.accepted = response
            guard let siblingRef = request.siblingRef else {return completion(.failure(.nilRecord))}
            let siblingsPredicate = NSPredicate(format: "%K==%@", argumentArray: ["recordID", siblingRef])
            fetchRequestsForProfile(predicate: siblingsPredicate) { result in
                switch result {
                case .success(let friends):
                    guard let friend = friends?.first else {return completion(.failure(.nilRecord))}
                    friend.accepted = response
                    let ownerReq = CKRecord(friend: request)
                    let friendReq = CKRecord(friend: friend)
                    
                    let ownerOperation = CKModifyRecordsOperation(recordsToSave: [ownerReq], recordIDsToDelete: nil)
                    ownerOperation.savePolicy = .changedKeys
                    ownerOperation.qualityOfService = .userInitiated
                    ownerOperation.modifyRecordsCompletionBlock = {records, _, error in
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let records = records else {return completion(.failure(.failedSavingRequest))}
                        let friendRequests = records.compactMap( { Friend(ckRecord: $0) } )
                        completion(.success(friendRequests))
                    }
                    let friendOperation = CKModifyRecordsOperation(recordsToSave: [friendReq], recordIDsToDelete: nil)
                    friendOperation.savePolicy = .changedKeys
                    friendOperation.qualityOfService = .userInitiated
                    friendOperation.modifyRecordsCompletionBlock = {records, _, error in
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let records = records else {return completion(.failure(.failedSavingRequest))}
                        let friendRequests = records.compactMap( { Friend(ckRecord: $0) } )
                        completion(.success(friendRequests))
                    }
                    self.publicDB.add(ownerOperation)
                    self.publicDB.add(friendOperation)
                    
                case .failure(let error):
                    return completion(.failure(.ckError(error)))
                }
            }
        case false:
            request.accepted = response
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [request.recordID])
            operation.savePolicy = .changedKeys
            operation.qualityOfService = .userInitiated
            operation.modifyRecordsCompletionBlock = {records, _, error in
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }
                guard let records = records else {return completion(.failure(.failedSavingRequest))}
                let friendRequests = records.compactMap( { Friend(ckRecord: $0) } )
                completion(.success(friendRequests))
            }
            self.publicDB.add(operation)
        }
    }
    
} //End of class


