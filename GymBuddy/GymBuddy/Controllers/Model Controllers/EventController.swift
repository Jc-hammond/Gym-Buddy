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
        
        let newEvent = Event(title: title, emoji: emoji, date: date, location: location, type: type, info: info, invitees: nil, inviteeRefs: nil, attendees: nil, attendeeRefs: nil, recordID: currentUser.recordID, userRef: userRef)
        
        let record = CKRecord(event: newEvent)
        
        publicDB.save(record) { record, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let event = Event(ckRecord: record) else {return completion(.failure(.nilRecord))}
            self.events.append(event)
            
        }
        completion(.success(newEvent))
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
 
}
