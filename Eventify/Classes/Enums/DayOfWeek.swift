//
//  DayOfWeek.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/3/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

//enum DayOfWeek: String {
//    case 1 = "sadsd"
//}

import Foundation

enum DayOfWeek: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
    
    var dayNumber: Int {
        get {
            return self.hashValue
        }
    }
    
    private static let days = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]
    
    static func fromNumber(number: Int) -> DayOfWeek {
        // FIXME check number index out of bounds
        return days[number]
    }
}
