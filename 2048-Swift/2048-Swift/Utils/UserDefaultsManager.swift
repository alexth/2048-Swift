//
//  UserDefaultsManager.swift
//  2048-Swift
//
//  Created by Alex Golub on 10/7/19.
//  Copyright © 2019 Alex Golub. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    private static let bestResultKey = "bestResultKey"
    private static let userDefaults = UserDefaults.standard
    
    static let fetchBest: UInt = {
        return UInt(UserDefaultsManager.userDefaults.integer(forKey: bestResultKey))
    }()
    
    static func store(best: UInt) {
        UserDefaultsManager.userDefaults.set(Int(best), forKey: bestResultKey)
    }
}
