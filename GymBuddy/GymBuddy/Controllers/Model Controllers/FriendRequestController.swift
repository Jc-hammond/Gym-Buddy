//
//  FriendController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

class FriendRequestController {
    
    //MARK: - Properties
    static let shared = FriendRequestController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func createFriendRequest(friendUser: User, completion: @escaping (Result<[FriendRequest]?, FriendError>) -> Void){
        
        guard let currentUser = UserController.shared.currentUser else {return completion(.failure(.noCurrentUser))}
        let ownerRef = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        let friendRef = CKRecord.Reference(recordID: friendUser.recordID, action: .deleteSelf)
        let ownerRequest = FriendRequest(ownerUserRef: ownerRef, friendUserRef: friendRef, userName: friendUser.fullName, ownerDidSend: true, accepted: false, siblingRef: nil)
        let ownerReqRef = CKRecord.Reference(recordID: ownerRequest.recordID, action: .deleteSelf)
        
        let friendRequest = FriendRequest(ownerUserRef: friendRef, friendUserRef: ownerRef, userName: currentUser.fullName, ownerDidSend: false, accepted: false, siblingRef: ownerReqRef)
        let friendReqRef = CKRecord.Reference(recordID: friendRequest.recordID, action: .deleteSelf)
        
        ownerRequest.siblingRef = friendReqRef
        
        //JCHUN - Is this correct?
//        friendUser.friendRequestRefs?.append(ownerReqRef)
//        currentUser.friendRequestRefs?.append(friendReqRef)
//
//        UserController.shared.saveUserUpdates(currentUser: currentUser) { result in
//            switch result {
//            case .success(_):
//                print("successfully saved the current user with friendRequestRef")
//            case .failure(let error):
//                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//            }
//        }
//
//        UserController.shared.saveUserUpdates(currentUser: friendUser) { result in
//            switch result {
//            case .success(_):
//                print("successfully saved the friend user with friendRequestRef")
//            case .failure(let error):
//                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//            }
//        }
        
        //JCHUN - above..
        
        let ownerRecord = CKRecord(friendRequest: ownerRequest)
        let friendRecord = CKRecord(friendRequest: friendRequest)
        var requests: [FriendRequest] = []
        
        publicDB.save(ownerRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }
                guard let record = record,
                      let owner = FriendRequest(ckRecord: record) else {return completion(.failure(.nilRecord))}
                requests.append(owner)
                
                self.publicDB.save(friendRecord) { record, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let record = record,
                              let friend = FriendRequest(ckRecord: record) else {return completion(.failure(.nilRecord))}
                        requests.append(friend)
                        completion(.success(requests))
                    }
                }
            }
        }
    }
    
    func fetchRequestsForProfile(predicate: NSPredicate, completion: @escaping (Result<[FriendRequest]?, FriendError>) -> Void) {
        
        let friendQuery = CKQuery(recordType: FriendRequestConstants.recordType, predicate: predicate)
        
        publicDB.perform(friendQuery, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.nilRecord))}
            let friends = records.compactMap({ FriendRequest(ckRecord: $0 )})
            completion(.success(friends))
        }
    }
    
    func fetchFriendRequests(friendRequestRefs: [CKRecord.Reference], completion: @escaping (Result<[FriendRequest], FriendError>) -> Void) {
        
        var recordIDs = [CKRecord.ID]()
        for reference in friendRequestRefs {
            let recordID = reference.recordID
            recordIDs.append(recordID)
        }
        
        let fetchOp = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        fetchOp.fetchRecordsCompletionBlock = { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.nilRecord))
                }
                
                if let records = records {
                    let friendRequests = records.compactMap{ FriendRequest(ckRecord: $0.value) }
                    completion(.success(friendRequests))
                }
            }
        }
        publicDB.add(fetchOp)
    }
    
    func toggleFriendAcceptance(response: Bool, request: FriendRequest, completion: @escaping (Result<[FriendRequest]?, FriendError>) -> Void) {
        
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
                    let ownerReq = CKRecord(friendRequest: request)
                    let friendReq = CKRecord(friendRequest: friend)
                    
                    let ownerOperation = CKModifyRecordsOperation(recordsToSave: [ownerReq], recordIDsToDelete: nil)
                    ownerOperation.savePolicy = .changedKeys
                    ownerOperation.qualityOfService = .userInitiated
                    ownerOperation.modifyRecordsCompletionBlock = {records, _, error in
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let records = records else {return completion(.failure(.failedSavingRequest))}
                        let friendRequests = records.compactMap( { FriendRequest(ckRecord: $0) } )
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
                        let friendRequests = records.compactMap( { FriendRequest(ckRecord: $0) } )
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
                let friendRequests = records.compactMap( { FriendRequest(ckRecord: $0) } )
                completion(.success(friendRequests))
            }
            self.publicDB.add(operation)
        }
    }
    
} //End of class


