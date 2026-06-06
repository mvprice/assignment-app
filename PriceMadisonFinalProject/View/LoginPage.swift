//
//  Login.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

struct LoginPage: View {
    @State var email = ""
    @State var password = ""
    @State var errorMessage: String = "error"
    @State var showAlert: Bool = false
    
    //navigation bools
    @State var signIn: Bool = false
    @State var signInComplete: Bool = false
    
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Login")
                    .font(Font.custom("BebasNeue-Regular", size: 100))
                    .foregroundStyle(pink)
                    .padding(80)
                
                Button{
                    //google login (same as sign in, but not saving to the database)
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                    
                    let config = GIDConfiguration(clientID: clientID)
                    
                    GIDSignIn.sharedInstance.configuration = config
                    
                    GIDSignIn.sharedInstance.signIn(withPresenting: self.getRootViewController()) { signResult, error in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        guard let user = signResult?.user,
                              let idToken = user.idToken else { return }
                        
                        let accessToken = user.accessToken
                        
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                        
                        Task{
                            // Use the credential to authenticate with Firebase
                            do{
                                let _ = try await Auth.auth().signIn(with: credential)
                                signInComplete = true
                            }catch{
                                errorMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                }label: {
                    Text("Login with Google here, or login below!")
                        .foregroundStyle(pink)
                }
                //go to home page after sign in
//                .navigationDestination(isPresented: $signInComplete) {
//                    MainTabPage()
//                        .navigationBarBackButtonHidden(true)
//                    //navigation is not working on the first login/sign up through google
//                }
                
                TextField("Email", text: $email)
                    .padding(12.0)
                    .background(Color.white)
                SecureField("Password", text: $password)
                    .padding(12.0)
                    .background(Color.white)
                
                Button{
                    Task{
                        do{
                            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
                            signInComplete = true
                        }catch{
                            errorMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }label: {
                    Text("Login")
                        .font(.title3)
                        .foregroundStyle(yellow)
                }
                .padding()
                .background(pink)
                //go to home page after sign in
                .navigationDestination(isPresented: $signInComplete) {
                    MainTabPage()
                        .navigationBarBackButtonHidden(true)
                }
                
                Button{
                    //go to sign up page
                    signIn = true
                }label: {
                    Text("Create an account here!")
                        .foregroundStyle(pink)
                }
                .navigationDestination(isPresented: $signIn) {
                   SignUpPage()
                        .navigationBarBackButtonHidden(true)
                }
                
                Spacer()
            }
            .padding()
            .background(orange)
            .alert("Login Error", isPresented: $showAlert) {
                Button("Ok"){} // Ok by default
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    NavigationStack{
        LoginPage()
    }
}
