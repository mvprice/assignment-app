//
//  HomePage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/4/23.
//

import SwiftUI

struct HomePage: View {
    @State var assignmentComplete = false
    @State var showMenu = false
    
//    var percentage: Double {
//        if assignmentViewModel.numberOfAssignments == 0 {
//            return 0.0
//        }else{
//            return (Double)(assignmentViewModel.numberComplete) / (Double)(assignmentViewModel.numberOfAssignments)
//        }
//    }
        
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    
    
    @State var percentage: Double = 0.0
    
    private func updatePercentage() {
        percentage = Double(assignmentViewModel.numberComplete) / Double(assignmentViewModel.numberOfAssignments)
    }
    
    var body: some View {
        NavigationStack{
            if let user = userViewModel.user{
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Welcome back,")
                                .font(Font.custom("BebasNeue-Regular", size: 65))
                                .multilineTextAlignment(.leading)
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                            Text(user.name)//\(name)")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                        }
                        Spacer()
                    }
                    
                    ZStack(alignment: .center){
                        if assignmentViewModel.numberOfAssignments == 0{
                            ProgressPage(percentage: 0) //needs to update when toggled
                        }else{
                            ProgressPage(percentage: percentage) //needs to update when toggled
                                .onAppear {
                                    updatePercentage()
                                }
                                .onChange(of: assignmentViewModel.numberComplete) {
                                    updatePercentage()
                                }
                                .onChange(of: assignmentViewModel.numberOfAssignments) {
                                    updatePercentage()
                                }
                        }
                        VStack{
                            Text("Completed")
                            Text("assignments:")
                            Text("\(assignmentViewModel.numberComplete) / \(assignmentViewModel.numberOfAssignments)")
                        }
                        .font(Font.custom("BebasNeue-Regular", size: 30))
                        .padding([.top], 15)
                        .foregroundStyle(salmon)
                    }
                    .frame(width: 200, height: 200)
                }
                VStack{
                    HStack{
                        Text("Todo:")//print out all asignments
                            .font(Font.custom("BebasNeue-Regular", size: 65))
                            .multilineTextAlignment(.leading)
                            .padding([.leading], 20)
                            .foregroundStyle(pink)
                        Spacer()
                    }
                    
                    ScrollView(showsIndicators: false){
                        ForEach($assignmentViewModel.assignments){ $assignment in
                            HomePageRow(assignment: assignment)
                                .environmentObject(assignmentViewModel)
                                .environmentObject(userViewModel)
                        }
                    }
                }
            }else{
                Spacer()
                HStack{
                    Spacer()
                    //while getting user, show loading screen
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack{
        HomePage()
            .environmentObject(AssignmentViewModel())
            .environmentObject(UserViewModel())
    }
}
