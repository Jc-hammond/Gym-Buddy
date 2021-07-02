//
//  Friend.swift
//  CloudKitTest2
//
//  Created by Connor Hammond on 6/25/21.
//

import Foundation
import CloudKit

struct FriendRequestConstants {
    static let recordType = "FriendRequest"
    static let ownerUserRefKey = "ownerUserRef"
    fileprivate static let friendUserRefKey = "friendUserRef"
    fileprivate static let userNameKey = "friendName"
    fileprivate static let ownerDidSendKey = "ownerDidSet"
    fileprivate static let acceptedKey = "accepted"
    static let siblingRefKey = "siblingRef"
}

class FriendRequest {
    
    var ownerUserRef: CKRecord.Reference
    var friendUserRef: CKRecord.Reference
    var userName: String
    var ownerDidSend: Bool
    var accepted: Bool
    var siblingRef: CKRecord.Reference?
    var recordID: CKRecord.ID
    
    init(ownerUserRef: CKRecord.Reference, friendUserRef: CKRecord.Reference, userName: String, ownerDidSend: Bool, accepted: Bool, siblingRef: CKRecord.Reference? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.ownerUserRef = ownerUserRef
        self.friendUserRef = friendUserRef
        self.userName = userName
        self.ownerDidSend = ownerDidSend
        self.accepted = accepted
        self.siblingRef = siblingRef
        self.recordID = recordID
    }
}


extension FriendRequest {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard
            let ownerUserRef = ckRecord[FriendRequestConstants.ownerUserRefKey] as? CKRecord.Reference,
            let friendUserRef = ckRecord[FriendRequestConstants.friendUserRefKey] as? CKRecord.Reference,
            let friendName = ckRecord[FriendRequestConstants.userNameKey] as? String,
            let ownerDidSend = ckRecord[FriendRequestConstants.ownerDidSendKey] as? Bool,
            let accepted = ckRecord[FriendRequestConstants.acceptedKey] as? Bool
        else { return nil }
        
        let siblingRef = ckRecord[FriendRequestConstants.siblingRefKey] as? CKRecord.Reference
        
        self.init(ownerUserRef: ownerUserRef, friendUserRef: friendUserRef, userName: friendName, ownerDidSend: ownerDidSend, accepted: accepted, siblingRef: siblingRef, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    
    convenience init(friendRequest: FriendRequest) {
        
        self.init(recordType: FriendRequestConstants.recordType, recordID: friendRequest.recordID)
        
        setValuesForKeys([
            FriendRequestConstants.ownerUserRefKey : friendRequest.ownerUserRef,
            FriendRequestConstants.friendUserRefKey : friendRequest.friendUserRef,
            FriendRequestConstants.userNameKey : friendRequest.userName,
            FriendRequestConstants.ownerDidSendKey : friendRequest.ownerDidSend,
            FriendRequestConstants.acceptedKey : friendRequest.accepted
        ])
        
        if let siblingRef = friendRequest.siblingRef {
            self.setValue(siblingRef, forKey: FriendRequestConstants.siblingRefKey)
        }
    }
}
