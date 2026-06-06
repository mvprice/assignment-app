//
//  HomePageRow.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/6/23.
//

import SwiftUI

struct HomePageRow: View {
    @State var assignment: Assignment
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    
    var body: some View {
        HStack{
            Text(assignment.title)
                .font(Font.custom("RobotoCondensed", size: 30))
            Button{
                //toggle assignment complete
                assignment.completed.toggle()
                assignmentViewModel.update(assignment: assignment)
            }label:{
                Image(systemName: assignment.completed ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .foregroundStyle(pink)
        }
    }
}

#Preview {
    HomePageRow(assignment: Assignment(
        id: UUID().uuidString,
        title: "Assignment 1",
        dueDate: "Jan 1, 2024",
        className: "ITP 342",
        completed: false,
        notes: "due tomorrow",
        userId: "1")
    )
}
