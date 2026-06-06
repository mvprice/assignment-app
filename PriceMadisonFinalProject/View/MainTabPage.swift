//
//  MainTabPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/5/23.
//

//Main tab page (creates state objects for both view models)(init show get data from db)
    //home page
    //calendar page
    //assignments page
        //assignment row
    //profile page

import SwiftUI

struct MainTabPage: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var assignmentViewModel = AssignmentViewModel()
    
    var body: some View {
        TabView {
            Group{
                HomePage()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                CalendarPage()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                NavigationView{
                    AssignmentsPage()
                }
                .tabItem {
                    Label("Assignments", systemImage: "list.bullet")
                }
                ProfilePage()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
            .environmentObject(userViewModel)
            .environmentObject(assignmentViewModel)
            .toolbarBackground(gold, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(pink)
    }
}

#Preview {
    NavigationStack{
        MainTabPage()
    }
}
