//
//  Date+Ext.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 7/7/24.
//

import Foundation

extension Date{
    var monthAndDay: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    var time: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    var year: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
}
