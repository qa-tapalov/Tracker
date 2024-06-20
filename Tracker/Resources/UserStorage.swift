//
//  UserStorage.swift
//  Tracker
//
//  Created by Андрей Тапалов on 17.06.2024.
//

import Foundation

final class UserStorage {
    
    static let shared = UserStorage()
    private let userDefaults = UserDefaults.standard
    private let skipOnboardingKey = "SkipOnboarding"
    var skipOnboarding: Bool {
        get {
            userDefaults.bool(forKey: skipOnboardingKey)
        }
        set {
            userDefaults.set(newValue, forKey: skipOnboardingKey)
        }
    }
    
    private init(){}
}
