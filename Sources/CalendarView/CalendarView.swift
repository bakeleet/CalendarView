//
//  CalendarView.swift
//  CalendarView
//
//  Created by bakeleet on 20/06/2024.
//

import SwiftUI


public struct CalendarView: View {

    private enum ViewConstants {
        static let numberOfElements = 7.0
        static let defaultSpacing = 4.0
    }

    @ObservedObject var viewModel = CalendarViewModel()
    
    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: ViewConstants.defaultSpacing) {
                    ForEach(Array(viewModel.days.enumerated()), id: \.element) { index, day in
                        VStack(alignment: .center, spacing: ViewConstants.defaultSpacing) {
                            Text(day.title)
                                .font(.caption2)
                                .foregroundStyle(viewModel.dateStringForegroundColor(for: day))
                            Text(day.subtitle)
                                .font(.callout)
                                .foregroundStyle(viewModel.dateStringForegroundColor(for: day))
                        }
                        .frame(
                            width: size(from: proxy.size.width),
                            height: size(from: proxy.size.width)
                        )
                        .background(content: {
                            viewModel.backgroundColor(for: day)
                                .cornerRadius(size(from: proxy.size.width) / 2)
                        })
                        .onAppear {
                            viewModel.loadMoreDaysIfNecessary(for: day)
                        }
                        .onTapGesture {
                            viewModel.didTapOnDay(at: index)
                        }
                    }
                    .flipsForRightToLeftLayoutDirection(true)
                    .environment(\.layoutDirection, .rightToLeft)
                }
            }
            .flipsForRightToLeftLayoutDirection(true)
            .environment(\.layoutDirection, .rightToLeft)
            .padding(.trailing, 2.0)
        }
    }

    private func size(from screenWidth: CGFloat) -> CGFloat {
        return (screenWidth - (7 * ViewConstants.defaultSpacing)) / ViewConstants.numberOfElements
    }
}
