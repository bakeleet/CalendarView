import XCTest
@testable import CalendarView

final class CalendarViewTests: XCTestCase {

    func testCalendarDayModel() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        var model = CalendarDayModel(date: Date(), isSelected: true)
        let modelDate = df.string(from: model.date)

        XCTAssertTrue(model.isSelected)
        XCTAssertEqual(modelDate, df.string(from: Date()))

        model = CalendarDayModel(date: Date())
        XCTAssertFalse(model.isSelected)

        df.dateFormat = "EEE"
        XCTAssertEqual(model.title, df.string(from: Date()))

        df.dateFormat = "d"
        XCTAssertEqual(model.subtitle, df.string(from: Date()))
    }
    
    private class CalendarViewModelDelegateMock: CalendarObserving {
        
        var didAutoSelectInitialDayCalled = false
        var dayDidAppearCalled = false
        var didTapDayCalled = false
        var initialHeight = 0.0
        
        func didTapDay(for date: Date) {
            didTapDayCalled.toggle()
        }
        
        func didAutoSelectInitialDay(_ date: Date) {
            didAutoSelectInitialDayCalled.toggle()
        }
        
        func dayDidAppear(for date: Date) {
            dayDidAppearCalled.toggle()
        }
        
        func didSetInitialHeight(_ height: CGFloat) {
            initialHeight = height
        }
    }
    
    func testCalendarViewModel() {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        
        let calendarViewModel = CalendarViewModel()
        let delegateMock = CalendarViewModelDelegateMock()
        calendarViewModel.delegate = delegateMock
        _ = CalendarView(viewModel: calendarViewModel)
        
        XCTAssertTrue(delegateMock.didAutoSelectInitialDayCalled)
        XCTAssertEqual(calendarViewModel.days.count, 1)

        calendarViewModel.dayAppeared(calendarViewModel.days.last!)
        XCTAssertTrue(delegateMock.dayDidAppearCalled)
        for i in 1...6 {
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) else { return }
            calendarViewModel.dayAppeared(CalendarDayModel(date: date))
        }
        XCTAssertEqual(calendarViewModel.days.count, 11)
        // this should fail on 3 day of each month and could probably be tested in a better way
        XCTAssertEqual(calendarViewModel.month, df.string(from: Date()))
        
        calendarViewModel.didTapOnDay(at: 0)
        XCTAssertTrue(delegateMock.didTapDayCalled)
        
        _ = calendarViewModel.size(from: 35)
        let expectation = self.expectation(description: "Test")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(delegateMock.initialHeight, 41.0)
    }
}
