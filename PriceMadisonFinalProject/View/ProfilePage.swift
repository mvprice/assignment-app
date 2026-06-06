//
//  ProfilePage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//


//2. update for email and password work, but cannot log in with new credentials!
//3. need to update the view after updating the email/password!
//4. how to remove navigation animation for first nav

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

func getTempPass(password: String) -> String{
    var tempPass = ""
    //creates a string of stars to mimic password
    for _ in password {
        tempPass += "*"
    }
    
    return tempPass
}

struct ProfilePage: View {
    @State var user: User?
    @State var signedInWithGoogle: Bool = false
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var changeEmail = false
    @State var changePassword = false
    @State var newEmail = ""
    @State var newPassword = ""
    
    @State var signedOut = false
    @State var navigate = false
    
    var body: some View {
        NavigationStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Profile")
                        .font(Font.custom("BebasNeue-Regular", size: 80))
                        .multilineTextAlignment(.leading)
                        .padding([.leading], 20)
                        .foregroundStyle(pink)
                                        
                    if let user = userViewModel.user { //how can I have this delay checking until it has time to load
                        if user.signedInWithGoogle == true {
                            //only show name and email with no option to change and sign out
                            Text("Name:")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                            //.padding([.top], 40)
                                .padding([.leading], 20)
                            Text(user.name)
                                .padding([.leading], 20)
                                .font(Font.custom("RobotoCondensed", size: 30))//new font
                            
                            Text("Email:")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                                .padding([.top], 20)
                                .padding([.leading], 20)
                            Text(user.email)
                                .padding([.leading], 20)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .tint(Color.black)
                            
                            Spacer()
                            
                            Button{
                                //sign out of account
                                do {
                                    try Auth.auth().signOut()
                                } catch{
                                    print(error)
                                }
                                //go to login page
                                signedOut = true
                            }label: {
                                Text("Sign out?")
                                    .font(Font.custom("BebasNeue-Regular", size: 60))
                                    .foregroundStyle(gold)
                                    .padding(5)
                            }
                            .background(pink)
                            .padding()
                            .alert("Sign out?", isPresented: $signedOut) {
                                //alert to confirm sign out
                                Button("Sign Out", role: .destructive){navigate = true}
                            }
                            .navigationDestination(isPresented: $navigate) {
                                LoginPage()
                                    .navigationBarBackButtonHidden(true)
                            }
                        }else{
                            //show everything
                            Text("Name:")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                                .padding([.leading], 20)
                            Text(user.name)
                                .padding([.leading], 20)
                                .font(Font.custom("RobotoCondensed", size: 30))//new font
                            
                            var email = user.email
                            Text("Email:")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                                .padding([.top], 20)
                                .padding([.leading], 20)
                            Text(changeEmail ? newEmail : email)
                                .padding([.leading], 20)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .tint(Color.black)
//                            Text(userViewModel.user?.email ?? user.email)
//                                .padding([.leading], 20)
//                                .font(Font.custom("RobotoCondensed", size: 30))
//                                .tint(Color.black)
                            
                            Button{
                                //change email
                                changeEmail = true
                            }label: {
                                Text("Change email?")
                            }
                            .font(Font.custom("BebasNeue-Regular", size: 25))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(pink)
                            .padding([.leading], 20)
                            .alert("Enter new email", isPresented: $changeEmail){
                                TextField("Enter new email", text: $newEmail)
                                Button("OK"){
                                    userViewModel.updateEmail(email: user.email, password: user.password, newEmail: newEmail)
                                }
                            }
                            
                            var password = user.password
                            //creates start sting to "hide" password
                            let tempPass = getTempPass(password: password)
                            
                            Text("Password:")
                                .font(Font.custom("BebasNeue-Regular", size: 60))
                                .multilineTextAlignment(.leading)
                                .padding([.top], 20)
                                .padding([.leading], 20)
//                            Text(tempPass) //hide
                            Text(changePassword ? getTempPass(password: newPassword) : tempPass)
                                .padding([.leading], 20)
                                .font(Font.custom("RobotoCondensed", size: 30))
                            
                            Button{
                                //change password
                                changePassword = true
                            }label: {
                                Text("Change password?")
                            }
                            .font(Font.custom("BebasNeue-Regular", size: 25))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(pink)
                            .padding([.leading], 20)
                            .alert("Enter new password", isPresented: $changePassword){
                                TextField("Enter new password", text: $newPassword)
                                Button("OK"){userViewModel.updatePassword(email: user.email, password: user.password, newPassword: newPassword)}
                                //save new password into the database
                            }
                            
                            Spacer()
                            
                            Button{
                                //sign out of account
                                let user = Auth.auth().currentUser
                                do {
                                    try Auth.auth().signOut()
                                } catch{
                                    print(error)
                                }
                                //go to login page
                                signedOut = true
                            }label: {
                                Text("Sign out?")
                                    .font(Font.custom("BebasNeue-Regular", size: 60))
                                    .foregroundStyle(gold)
                                    .padding(5)
                            }
                            .background(pink)
                            .padding()
                            .alert("Sign out?", isPresented: $signedOut) {
                                //alert to confirm sign out
                                Button("Sign Out", role: .destructive){navigate = true}
                                //save user and assignments to database
                            }
                            .navigationDestination(isPresented: $navigate) {
                                LoginPage()
                                    .navigationBarBackButtonHidden(true)
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
                    
                    if let errorMessage = userViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfilePage()
            .environmentObject(AssignmentViewModel())
            .environmentObject(UserViewModel())
    }
}
