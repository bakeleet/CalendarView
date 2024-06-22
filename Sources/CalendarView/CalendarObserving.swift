//
//  CalendarObserving.swift
//  CalendarView
//
//  Created by bakeleet on 22/06/2024.
//

import SwiftUI


public protocol CalendarObserving: AnyObject {

    func didTapDay(for date: Date)

    func dayDidAppear(for date: Date)

    func didAutoSelectInitialDay(_ date: Date)

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
