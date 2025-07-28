//
//  ParameterStorage.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

import Foundation

@propertyWrapper
struct ParameterStorage<Value: Codable> {
    private let key: ParamStorageKey
    private let defaultValue: Value

    init(key: ParamStorageKey, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: Value {
        get {
            let value = UserDefaults.standard.value(forKey: key.rawValue)
            return (value as? Value) ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}
