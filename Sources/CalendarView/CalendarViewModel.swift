//
//  CalendarViewModel.swift
//  CalendarView
//
//  Created by bakeleet on 20/06/2024.
//

import SwiftUI


public final class CalendarViewModel: ObservableObject {

    public enum ViewConstants {
        static let numberOfElements = 7.0
        static let defaultSpacing = 4.0
    }

    @Published private(set) var days = [
        CalendarDayModel(date: Date(), isSelected: true)
    ]
    @Published private(set) var month = ""
    
    public weak var delegate: CalendarObserving? {
        didSet {
            guard let today = days.last else { return }
            delegate?.didAutoSelectInitialDay(today.date)
        }
    }

    private var selectedDayIndex = 0
    private var visibleDays: Set<CalendarDayModel> = []
    private var didSetHeightOnFirstLoad = false

    private let monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
    public init() {}

    func dayAppeared(_ day: CalendarDayModel) {
        loadMoreDaysIfNecessary(for: day)

        visibleDays.insert(day)
        setMonthText()

        delegate?.dayDidAppear(for: day.date)
    }

    func dayDisappeared(_ day: CalendarDayModel) {
        visibleDays.remove(day)
        setMonthText()
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
        delegate?.didTapDay(for: days[index].date)
    }

    func size(from screenWidth: CGFloat) -> CGFloat {
        let size = (screenWidth - (7 * ViewConstants.defaultSpacing)) / ViewConstants.numberOfElements
        setHeight(size + 40)
        return size
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

    private func setHeight(_ height: CGFloat) {
        guard didSetHeightOnFirstLoad == false else {
            return
        }
        didSetHeightOnFirstLoad = true
        DispatchQueue.main.async {
            self.delegate?.didSetInitialHeight(height)
        }
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

    private func updateSelection(_ index: Int) {
        days[selectedDayIndex].isSelected.toggle()
        days[index].isSelected.toggle()
        selectedDayIndex = index
    }

    private func setMonthText() {
        guard visibleDays.count == 7 else {
            return
        }

        var monthNumberForVisibleDays = [Int]()
        visibleDays.forEach {
            monthNumberForVisibleDays.append(Calendar.current.component(.month, from: $0.date))
        }
        updateMonthText(for: monthNumberForVisibleDays)
    }

    private func updateMonthText(for days: [Int]) {
        var dictionaryToCount = [Int: Int]()
        days.forEach {
            dictionaryToCount[$0, default: 0] += 1
        }

        var maxCount = 0
        var mostFrequentElement: Int?

        for (element, count) in dictionaryToCount {
            if count > maxCount {
                maxCount = count
                mostFrequentElement = element
            }
        }

        if let mostFrequentElement = mostFrequentElement {
            month = monthFormatter.monthSymbols[mostFrequentElement - 1]
        }
    }
}
