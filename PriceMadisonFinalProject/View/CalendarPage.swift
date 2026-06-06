//
//  CalendarPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/5/23.
//

import SwiftUI
import UIKit
import FSCalendar

struct CalendarPage: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    
    @State var selectedDate = Date()
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                CalendarViewRepresentable(selectedDate: $selectedDate)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading){
                    Text("Assignments:")
                        .font(Font.custom("BebasNeue-Regular", size: 60))
                        .foregroundStyle(pink)
                        .padding([.leading], 20)
                    VStack{
                        ScrollView{
                            //if assignment due date == selected date, show assignment row
                            ForEach($assignmentViewModel.assignments){ $assignment in
                                if getDate(dueDate: assignment.dueDate) == selectedDate {
                                    CalendarAssignmentRow(assignment: assignment)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

func getDate(dueDate: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    return dateFormatter.date(from: dueDate)!
}


struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        // Delegate & Data source
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // Event Options
        calendar.appearance.eventDefaultColor = UIColor.yellow
        calendar.appearance.todayColor = UIColor.orange
        calendar.appearance.selectionColor = UIColor.systemPink
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable

        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar,
                        didSelect date: Date,
                        at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}

#Preview {
    CalendarPage()
        .environmentObject(AssignmentViewModel())
        .environmentObject(UserViewModel())
}
