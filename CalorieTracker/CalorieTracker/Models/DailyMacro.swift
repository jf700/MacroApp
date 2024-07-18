//
//  DailyMacro.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 7/7/24.
//

import Foundation

struct DailyMacro: Identifiable{
    let id = UUID()
    let date: Date
    let carbs: Int
    let fats: Int
    let protein: Int
    
}
