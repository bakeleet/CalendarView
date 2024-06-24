//
//  CalendarObserving.swift
//  CalendarView
//
//  Created by bakeleet on 22/06/2024.
//

import SwiftUI


public protocol CalendarObserving: AnyObject {

    /// Implement this method if you want to get notified when user selects day in calendar.
    /// - Parameter date: The `Date` of the tapped day.
    func didTapDay(for date: Date)

    /// Implement this method if you want to get notified when a day from calendar appears.
    /// - Parameter date: The `Date`  of the day that appeared on the screen.
    func dayDidAppear(for date: Date)

    /// This method will be called when the calendar first appears and today is auto selected.
    /// - Parameter date: The `Date` of initialy selected date, which is always today.
    func didAutoSelectInitialDay(_ date: Date)

    /// Implement this method if you want to set calendar height to value computed automatically based on visible elements.
    /// - Parameter height: Height computed for the space available for the calendar's width.
    func didSetInitialHeight(_ height: CGFloat)
}

public extension CalendarObserving {

    func dayDidAppear(for date: Date) {
        
    }

    func didAutoSelectInitialDay(_ date: Date) {
        
    }
    
    func didSetInitialHeight(_ height: CGFloat) {
        
    }
}
