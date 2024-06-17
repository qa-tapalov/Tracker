//
//  Tracker.swift
//  Tracker
//
//  Created by Андрей Тапалов on 08.04.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emogi: String
    let schedule: [Int]
}

enum WeekDay: Int, Codable {
    case sunday = 1
    case monday = 2
    case thusday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}
