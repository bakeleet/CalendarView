//
//  CalendarView.swift
//  CalendarView
//
//  Created by bakeleet on 20/06/2024.
//

import SwiftUI


public struct CalendarView: View {

    @ObservedObject var viewModel: CalendarViewModel
    
    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(viewModel.month)
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: CalendarViewModel.ViewConstants.defaultSpacing) {
                        ForEach(Array(viewModel.days.enumerated()), id: \.element) { index, day in
                            VStack(alignment: .center, spacing: CalendarViewModel.ViewConstants.defaultSpacing) {
                                Text(day.title)
                                    .font(.caption2)
                                    .foregroundStyle(viewModel.dateStringForegroundColor(for: day))
                                Text(day.subtitle)
                                    .font(.callout)
                                    .foregroundStyle(viewModel.dateStringForegroundColor(for: day))
                            }
                            .frame(
                                width: viewModel.size(from: proxy.size.width),
                                height: viewModel.size(from: proxy.size.width)
                            )
                            .background(content: {
                                viewModel.backgroundColor(for: day)
                                    .cornerRadius(viewModel.size(from: proxy.size.width) / 2)
                            })
                            .onAppear {
                                viewModel.dayAppeared(day)
                            }
                            .onDisappear {
                                viewModel.dayDisappeared(day)
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
    }
}
