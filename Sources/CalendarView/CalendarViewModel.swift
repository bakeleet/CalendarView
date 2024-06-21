//
//  CalendarViewModel.swift
//  CalendarView
//
//  Created by bakeleet on 20/06/2024.
//

import SwiftUI


public final class CalendarViewModel: ObservableObject {
    
    @Published private(set) var days = [
        CalendarDayModel(date: Date(), isSelected: true)
    ]

    private var selectedDayIndex = 0

    func loadMoreDaysIfNecessary(for dayModel: CalendarDayModel) {
        guard dayModel == days.last else { return }

        loadMoreDates()
    }

    func didTapOnDay(at index: Int) {
        let lastElementIndex = days.count - 1
        if selectedDayIndex == lastElementIndex || index == lastElementIndex {
            updateSelection(index)
        } else {
            withAnimation {
                updateSelection(index)
            }
        }
    }

    func dateStringForegroundColor(for day: CalendarDayModel) -> Color {
        if day.isSelected {
            return .white
        } else if day.date == days.first?.date {
            return .blue
        } else {
            return Color(uiColor: .label)
        }
    }
    
    func backgroundColor(for day: CalendarDayModel) -> Color {
        if day.isSelected {
            return Color.blue
        } else if day.date == days.first?.date {
            return Color.blue.opacity(0.25)
        } else {
            return Color.clear
        }
    }

    // MARK: - Private

    private func updateSelection(_ index: Int) {
        days[selectedDayIndex].isSelected.toggle()
        days[index].isSelected.toggle()
        selectedDayIndex = index
    }

    private func loadMoreDaysIfNecessary(for dayModel: CalendarDayModel) {
        guard dayModel == days.last else { return }

        loadMoreDays()
    }

    private func loadMoreDays() {
        let startDate = days.last?.date ?? Date()
        for i in 1...10 {
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: startDate) else { return }
            let dateModel = CalendarDayModel(date: date)
            days.append(dateModel)
        }
    }
}
