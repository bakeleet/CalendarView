//
//  CalendarDayModel.swift
//  CalendarView
//
//  Created by bakeleet on 20/06/2024.
//

import Foundation


struct CalendarDayModel: Hashable {

    let date: Date
    
    var isSelected: Bool = false

    var title: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
    
    var subtitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
