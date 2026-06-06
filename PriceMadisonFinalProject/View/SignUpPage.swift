//
//  SignUp.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

struct SignUpPage: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var errorMessage: String = "error"
    @State var showAlert: Bool = false
    @State var googleSignIn: Bool = false
    
    //navigation bools
    @State var logIn: Bool = false
    @State var signInComplete: Bool = false
    
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Sign Up")
                    .font(Font.custom("BebasNeue-Regular", size: 100))
                    .foregroundStyle(orange)
                    .padding(60)
                
                Button{
                    //google signup
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
                                let authResult = try await Auth.auth().signIn(with: credential)
                                
                                let gUserId = authResult.user.uid
                                email = user.profile?.email ?? "" //will use in profile page and check for empty string
                                name = user.profile?.name ?? ""
                                googleSignIn = true
                                signInComplete = true
                                //add to database
                                try await Firestore.firestore().collection("users").document(gUserId).setData([
                                    "id": gUserId,
                                    "name": name,//how to get name from google sign in
                                    "email": email,
                                    "password": "",
                                    "signedInWithGoogle": googleSignIn
                                ])
                            }catch{
                                errorMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                }label: {
                    Text("Sign up with Google here, or sign up below!")
                        .foregroundStyle(orange)
                }
//                .navigationDestination(isPresented: $signInComplete) {
//                    MainTabPage()
//                        .navigationBarBackButtonHidden(true)
//                }
                
                TextField("Name", text: $name)
                    .padding(12.0)
                    .background(Color.white)
                TextField("Email", text: $email)
                    .padding(12.0)
                    .background(Color.white)
                SecureField("Password", text: $password)
                    .padding(12.0)
                    .background(Color.white)
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding(12.0)
                    .background(Color.white)
                
                Button{
                    //signup functionality
                    if password != confirmPassword{
                        //passwords do not match error
                        errorMessage = "Passwords do not match"
                        showAlert = true
                    }else{
                        _ = User(
                            id: UUID().uuidString,
                            name: name,
                            email: email,
                            password: password,
                            signedInWithGoogle: false
                        )
                        
                        Task{
                            do{
                                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                                
                                let userId = result.user.uid
                                
                                try await Firestore.firestore().collection("users").document(userId).setData([
                                    "id": userId,
                                    "name": name,
                                    "email": email,
                                    "password": password,
                                    "signedInWithGoogle": googleSignIn
                                ])
                                
                                signInComplete = true
                            }catch{
                                errorMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    
                }label: {
                    Text("Sign Up")
                        .font(.title3)
                        .foregroundStyle(pink)
                }
                .padding()
                .background(orange)
                //go to home page after sign in
                .navigationDestination(isPresented: $signInComplete) {
                    MainTabPage()
                        .navigationBarBackButtonHidden(true)
                }
                
                Button{
                    //go to login page
                    logIn = true
                }label: {
                    Text("Already have an account? Log in here!")
                        .foregroundStyle(orange)
                }
                .navigationDestination(isPresented: $logIn) {
                    LoginPage()
                        .navigationBarBackButtonHidden(true)
                }
                Spacer()
            }
            .padding()
            .background(pink)
            .alert("Sign Up Error", isPresented: $showAlert) {
                Button("Ok"){} // Ok by default
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    NavigationStack{
        SignUpPage()
    }
}
