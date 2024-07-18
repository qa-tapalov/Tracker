//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Андрей Тапалов on 18.07.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController(){
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image)
    }

}
