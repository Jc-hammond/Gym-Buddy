//
//  FriendError.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/30/21.
//

import Foundation

enum FriendError: LocalizedError {
    case ckError(Error)
    case noCurrentUser
    case failedSavingRequest
    case nilRecord
    case noSiblingFound
}
