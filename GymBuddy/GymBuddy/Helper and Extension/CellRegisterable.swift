//
//  CellRegisterable.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

protocol CellRegisterable where Self: UIView {
    static var id: String { get }
    static var nib: UINib { get }
}

extension CellRegisterable {
    static var id: String {
        "\(Self.self)"
    }
    
    static var nib: UINib {
        UINib(nibName: id, bundle: nil)
    }
}
