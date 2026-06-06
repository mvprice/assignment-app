//
//  AssignmentRow.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/6/23.
//

import SwiftUI

struct CalendarAssignmentRow: View {
    @State var assignment: Assignment
    
    var body: some View {
        HStack{
            Image(systemName: "square.and.pencil.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.leading, 20)
            
            VStack(alignment: .leading) {
                Text(assignment.title)
                    .font(Font.custom("BebasNeue-Regular", size: 30))
                
                Text("Due: \(assignment.dueDate)")
                    .font(Font.custom("RobotoCondensed", size: 15))
                
                Text("Class: \(assignment.className)")
                    .font(Font.custom("RobotoCondensed", size: 15))
            }
        }
    }
}

#Preview {
    CalendarAssignmentRow(assignment:
                    Assignment(
                        id: UUID().uuidString,
                        title: "Assignment 1",
                        dueDate: "Jan 1, 2024",
                        className: "ITP 342",
                        completed: false,
                        notes: "due tomorrow",
                        userId: "1")
    )
}
