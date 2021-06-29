//
//  Event.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit

struct EventStrings {
    
    static let recordType = "Event"
    static let titleKey = "title"
    static let emojiKey = "emoji"
    static let dateKey = "date"
    static let locationKey = "location"
    static let typeKey = "type"
    static let infoKey = "info"
    static let acceptedKey = "accepted"
    static let ownerDidSendKey = "ownerDidSend"
    static let inviteesKey = "invitees"
    static let inviteeRefsKey = "inviteeRefs"
    static let userRefKey = "userRef"
}



class Event {
    
    
    var title: String
    var emoji: String
    var date: String
    var location: String
    var type: String
    var info: String?
    var accepted: Bool
    var ownerDidSend: Bool
    var invitees: [Friend]?
    var inviteeRefs: [CKRecord.Reference]?
    var recordID: CKRecord.ID
    var userRef: CKRecord.Reference
    
    init(title: String, emoji: String, date: String, location: String, type: String, info: String?, accepted: Bool, ownerDidSend: Bool, invitees: [Friend]?, inviteeRefs: [CKRecord.Reference]?, recordID: CKRecord.ID, userRef: CKRecord.Reference) {
        self.title = title
        self.emoji = emoji
        self.date = date
        self.location = location
        self.type = type
        self.info = info
        self.accepted = accepted
        self.ownerDidSend = ownerDidSend
        self.invitees = invitees
        self.inviteeRefs = inviteeRefs
        self.recordID = recordID
        self.userRef = userRef
    }
}

extension Event {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EventStrings.titleKey] as? String,
              let emoji = ckRecord[EventStrings.emojiKey] as? String,
              let date = ckRecord[EventStrings.dateKey] as? String,
              let location = ckRecord[EventStrings.locationKey] as? String,
              let type = ckRecord[EventStrings.typeKey] as? String,
              let accepted = ckRecord[EventStrings.acceptedKey] as? Bool,
              let ownerDidSend = ckRecord[EventStrings.ownerDidSendKey] as? Bool,
              let userRef = ckRecord[EventStrings.userRefKey] as? CKRecord.Reference
              else {return nil}
        
            let info = ckRecord[EventStrings.infoKey] as? String
            let inviteeRefs = ckRecord[EventStrings.inviteeRefsKey] as? [CKRecord.Reference]
        
        self.init(title: title, emoji: emoji, date: date, location: location, type: type, info: info, accepted: accepted, ownerDidSend: ownerDidSend, invitees: nil, inviteeRefs: inviteeRefs, recordID: ckRecord.recordID, userRef: userRef)
    }
}

extension CKRecord {
    
    convenience init(event: Event) {
        
        self.init(recordType: EventStrings.recordType, recordID: event.recordID)
        
        self.setValuesForKeys([
            EventStrings.titleKey : event.title,
            EventStrings.emojiKey : event.emoji,
            EventStrings.dateKey : event.date,
            EventStrings.locationKey : event.location,
            EventStrings.typeKey : event.type,
            EventStrings.acceptedKey : event.accepted,
            EventStrings.ownerDidSendKey : event.ownerDidSend,
            EventStrings.userRefKey : event.userRef
        ])
        
        if let inviteeRefs = event.inviteeRefs {
            self.setValue(inviteeRefs, forKey: EventStrings.inviteeRefsKey)
        }
        
        if let info = event.info {
            self.setValue(info, forKey: EventStrings.infoKey)
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
