//
//  UserError.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation


enum UserError: LocalizedError {
    
    case ckError(Error)
    case noRecord
    case noProfile
    case initFromRecordFailure
    case nilRecord
    case noAppleUser
    
    var localizedDescription: String {
        switch self {
        case .ckError(let error):
            return "There was an error returned from cloudkit. Error: \(error)"
        case .noRecord:
            return "No record was returned from cloudkit"
        case .noProfile:
            return "The profile was not found"
        case .initFromRecordFailure:
            return "init from record failure"
        case .nilRecord:
            return "nil record"
        case .noAppleUser:
            return "no apple user record"
        }
    }
}
