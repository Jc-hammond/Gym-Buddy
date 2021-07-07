//
//  EventController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation
import CloudKit


class EventController {
    
    //MARK: - Properties
    static let shared = EventController()
    var events: [Event] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Functions
    
    func createEvent(with title: String, emoji: String, date: Date, location: String, type: String, info: String?, user: User, completion: @escaping (Result<Event?, EventError>) -> Void) {
        
        guard let currentUser = UserController.shared.currentUser else {return completion(.failure(.noProfile))}
        let userRef = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        
        let newEvent = Event(title: title, emoji: emoji, date: date, location: location, type: type, info: info, invitees: nil, attendees: nil, userRef: userRef)
        
        let record = CKRecord(event: newEvent)
        
        publicDB.save(record) { record, error in
            if let error = error {
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let event = Event(ckRecord: record) else {return completion(.failure(.nilRecord))}
            self.events.append(event)
            
        }
        completion(.success(newEvent))
    }
    
    func inviteTo(event: Event, invitee: User, completion: @escaping (Result<Event?, EventError>) -> Void ) {
        
        let inviteeID = invitee.recordID
        let inviteeRef = CKRecord.Reference(recordID: inviteeID, action: .deleteSelf)
        
        event.inviteeRefs.append(inviteeRef)
        
        let record = CKRecord(event: event)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _ , error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.nilRecord))}
            
            guard let eventToUpdate = Event(ckRecord: record) else {return completion(.failure(.nilRecord))}
            
            completion(.success(eventToUpdate))
        }
        publicDB.add(operation)
        
    }
    
    func acceptInvite(event: Event, user: User, completion: @escaping (Result<Event?, EventError>) -> Void) {
        
        let inviteeID = user.recordID
        let inviteeRef = CKRecord.Reference(recordID: inviteeID, action: .deleteSelf)
        
        guard let index = event.inviteeRefs.firstIndex(of: inviteeRef) else {return}
        event.inviteeRefs.remove(at: index)
        
        event.attendeeRefs.append(inviteeRef)
        
        let record = CKRecord(event: event)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _ , error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.nilRecord))}
            
            guard let eventToUpdate = Event(ckRecord: record) else {return completion(.failure(.nilRecord))}
            
            completion(.success(eventToUpdate))
        }
        publicDB.add(operation)
    }
    
    
    func updateEvent(for event: Event, completion: @escaping (Result<Event?, EventError>) -> Void) {
        
        let record = CKRecord(event: event)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _ , error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.nilRecord))}
            
            guard let eventToUpdate = Event(ckRecord: record) else {return completion(.failure(.nilRecord))}
            
            completion(.success(eventToUpdate))
        }
        publicDB.add(operation)
        
    }
    
//    let predicate = NSPredicate(format: "%K == %@", EventStrings.attendeeRefsKey, UserController.shared.currentUserRef)
    
    func fetchEvent(predicate: NSPredicate, completion: @escaping (Result<[Event]?, EventError>) -> Void) {
        let eventQuery = CKQuery(recordType: EventStrings.recordType, predicate: predicate)
        
        self.publicDB.perform(eventQuery, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else {return completion(.failure(.nilRecord))}
            
            let events = records.compactMap({ Event(ckRecord: $0)})
            
            if !events.isEmpty {
                completion(.success(events))
            } else {
                completion(.failure(.nilRecord))
            }
        }
    }
    
    
    //JCHUN - Does this work?
    func fetchEventAttendees(attendeeRefs: [CKRecord.Reference], completion: @escaping (Result<[User]?, EventError>) -> Void) {
        
        var recordIDs = [CKRecord.ID]()
        for reference in attendeeRefs {
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
                    let attendees = records.compactMap{ User(ckRecord: $0.value) }
                    completion(.success(attendees))
                }
            }
        }
        publicDB.add(fetchOp)
        
//        for reference in attendeeRefs {
//
//            publicDB.fetch(withRecordID: reference.recordID) { record, error in
//                if let error = error {
//                    completion(.failure(.ckError(error)))
//                }
//
//                guard let record = record,
//                      let user = User(ckRecord: record) else { return completion(.failure(.noRecord)) }
//
//                attendees.append(user)
//            }
//        }
//
//        completion(.success(attendees))
    }
    
    func deleteEvent(event: Event, completion: @escaping (Result<Bool, EventError>) -> Void) {
        
        let deleteOp = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [event.recordID])
        deleteOp.savePolicy = .changedKeys
        deleteOp.qualityOfService = .userInteractive
        deleteOp.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            if records?.count == 0 {
                print("Deleted Event from CK")
                completion(.success(true))
            } else {
                return completion(.failure(.noRecord))
            }
        }
        publicDB.add(deleteOp)
    }
 
}//End of class
