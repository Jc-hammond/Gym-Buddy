//
//  Friend.swift
//  CloudKitTest2
//
//  Created by Connor Hammond on 6/25/21.
//

import Foundation
import CloudKit

struct FriendConstants {
    static let recordType = "Friend"
    static let ownerUserRefKey = "ownerUserRef"
    fileprivate static let friendUserRefKey = "friendUserRef"
    fileprivate static let friendNameKey = "friendName"
    fileprivate static let ownerDidSendKey = "ownerDidSet"
    fileprivate static let acceptedKey = "accepted"
    static let siblingRefKey = "siblingRef"
}

class Friend {
    
    var ownerUserRef: CKRecord.Reference
    var friendUserRef: CKRecord.Reference
    var friendName: String
    var ownerDidSend: Bool
    var accepted: Bool
    var siblingRef: CKRecord.Reference?
    var recordID: CKRecord.ID
    
    init(ownerUserRef: CKRecord.Reference, friendUserRef: CKRecord.Reference, friendName: String, ownerDidSend: Bool, accepted: Bool, siblingRef: CKRecord.Reference? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.ownerUserRef = ownerUserRef
        self.friendUserRef = friendUserRef
        self.friendName = friendName
        self.ownerDidSend = ownerDidSend
        self.accepted = accepted
        self.siblingRef = siblingRef
        self.recordID = recordID
    }
}


extension Friend {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard
            let ownerUserRef = ckRecord[FriendConstants.ownerUserRefKey] as? CKRecord.Reference,
            let friendUserRef = ckRecord[FriendConstants.friendUserRefKey] as? CKRecord.Reference,
            let friendName = ckRecord[FriendConstants.friendNameKey] as? String,
            let ownerDidSend = ckRecord[FriendConstants.ownerDidSendKey] as? Bool,
            let accepted = ckRecord[FriendConstants.acceptedKey] as? Bool
        else { return nil }
        
        let siblingRef = ckRecord[FriendConstants.siblingRefKey] as? CKRecord.Reference
        
        self.init(ownerUserRef: ownerUserRef, friendUserRef: friendUserRef, friendName: friendName, ownerDidSend: ownerDidSend, accepted: accepted, siblingRef: siblingRef, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    
    convenience init(friend: Friend) {
        
        self.init(recordType: FriendConstants.recordType, recordID: friend.recordID)
        
        setValuesForKeys([
            FriendConstants.ownerUserRefKey : friend.ownerUserRef,
            FriendConstants.friendUserRefKey : friend.friendUserRef,
            FriendConstants.friendNameKey : friend.friendName,
            FriendConstants.ownerDidSendKey : friend.ownerDidSend,
            FriendConstants.acceptedKey : friend.accepted
        ])
        
        if let siblingRef = friend.siblingRef {
            self.setValue(siblingRef, forKey: FriendConstants.siblingRefKey)
        }
    }
}
