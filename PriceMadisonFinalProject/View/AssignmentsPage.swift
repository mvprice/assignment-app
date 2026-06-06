//
//  AssignmentsPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/5/23.
//

import SwiftUI

struct AssignmentsPage: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    
    @State var newAssignment = false
    @State var navigateToAssignments = false
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Assignments")
                        .font(Font.custom("BebasNeue-Regular", size: 80))
                        .padding([.leading], 20)
                        .foregroundStyle(pink)
                    Spacer()
                }
                .background(gold)
                
                Button{
                    newAssignment = true
                }label: {
                    Label("Add Assignment", systemImage: "plus")
                        .font(Font.custom("RobotoCondensed", size: 20))
                        .foregroundStyle(pink)                
                }
                .navigationDestination(isPresented: $newAssignment) {
                    EditAssignmentPage(user: userViewModel.user)
                        .environmentObject(assignmentViewModel)
                        .environmentObject(userViewModel)
                        .navigationBarBackButtonHidden(true)
                }
                
                List($assignmentViewModel.assignments) { $assignment in
                    NavigationLink{
                        EditAssignmentPage(assignment: assignment, user: userViewModel.user)
                            .environmentObject(assignmentViewModel)
                            .environmentObject(userViewModel)
                            .tint(orange)
                    } label: {
                        AssignmentRow(assignment: assignment)
                            .foregroundStyle(pink)
                    }
                    .tint(orange)
                }
                .tint(pink)
            }
        }
    }
}

#Preview {
    NavigationView{
        AssignmentsPage()
            .environmentObject(AssignmentViewModel())
            .environmentObject(UserViewModel())
    }
}
