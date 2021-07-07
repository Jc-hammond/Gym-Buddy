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
    static let attendeeRefsKey = "attendeeRefs"
    static let attendeesKey = "attendees"
    static let userRefKey = "userRef"
}



class Event {
    
    
    var title: String
    var emoji: String
    var date: Date
    var location: String
    var type: String
    var info: String?
//    var ownerDidSend: Bool
    var invitees: [User]?
    var inviteeRefs: [CKRecord.Reference]?
    var attendees: [User]?
    var attendeeRefs: [CKRecord.Reference]?
    var recordID: CKRecord.ID
    var userRef: CKRecord.Reference
    
    init(title: String, emoji: String, date: Date, location: String, type: String, info: String?, invitees: [User]?, inviteeRefs: [CKRecord.Reference]?, attendees: [User]?, attendeeRefs: [CKRecord.Reference]?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userRef: CKRecord.Reference) {
        self.title = title
        self.emoji = emoji
        self.date = date
        self.location = location
        self.type = type
        self.info = info
//        self.ownerDidSend = ownerDidSend
        self.invitees = invitees
        self.inviteeRefs = inviteeRefs
        self.attendees = attendees
        self.attendeeRefs = attendeeRefs
        self.recordID = recordID
        self.userRef = userRef
    }
}

extension Event {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EventStrings.titleKey] as? String,
              let emoji = ckRecord[EventStrings.emojiKey] as? String,
              let date = ckRecord[EventStrings.dateKey] as? Date,
              let location = ckRecord[EventStrings.locationKey] as? String,
              let type = ckRecord[EventStrings.typeKey] as? String,
              //              let ownerDidSend = ckRecord[EventStrings.ownerDidSendKey] as? Bool,
              let userRef = ckRecord[EventStrings.userRefKey] as? CKRecord.Reference
        else {return nil}
        
        let info = ckRecord[EventStrings.infoKey] as? String
        let inviteeRefs = ckRecord[EventStrings.inviteeRefsKey] as? [CKRecord.Reference]
        let attendeeRefs = ckRecord[EventStrings.attendeeRefsKey] as? [CKRecord.Reference]
        
        self.init(title: title, emoji: emoji, date: date, location: location, type: type, info: info, invitees: nil, inviteeRefs: inviteeRefs, attendees: nil, attendeeRefs: attendeeRefs, recordID: ckRecord.recordID, userRef: userRef)
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
//            EventStrings.ownerDidSendKey : event.ownerDidSend,
            EventStrings.userRefKey : event.userRef
        ])
        
        if let info = event.info {
            self.setValue(info, forKey: EventStrings.infoKey)
        }
        if let inviteeRefs = event.inviteeRefs {
            self.setValue(inviteeRefs, forKey: EventStrings.inviteeRefsKey)
        }
        if let attendeeRefs = event.attendeeRefs {
            self.setValue(attendeeRefs, forKey: EventStrings.attendeeRefsKey)
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
