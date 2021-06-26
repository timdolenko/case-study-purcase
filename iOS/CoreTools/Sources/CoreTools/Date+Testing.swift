//
//  Date+Testing.swift
//

import Foundation

// MARK:  Date.init()
public var __date_current: () -> Date = {
    Date()
}

extension Date {
    public static var now: Date {
        return __date_current()
    }
}

extension Date {
    public static func overrideCurrentDate(_ date: @autoclosure @escaping () -> Date) {
        __date_current = date
    }
}
