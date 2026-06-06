//
//  UserViewModel.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject{
    @Published var user: User? 
    @Published var errorMessage: String?
        
    init(){
        if let user = Auth.auth().currentUser {
            // The user's ID, unique to the Firebase project.
            let uid = user.uid
            
            //access the database to get other user info
            let currentUser = Firestore.firestore().collection("users").document(uid)
            
            currentUser.getDocument { document, error in
                if let error = error {
                    self.errorMessage = "Error getting user: \(error.localizedDescription)"
                }else{
                    if let document = document, document.exists {
                        do {
                            self.user = try document.data(as: User.self)
                            self.objectWillChange.send()
                        }catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }else{
                        self.errorMessage = "User document does not exist"
                    }
                }
            }
        }
        objectWillChange.send()
    }
    
    func updateEmail(email: String, password: String, newEmail: String){
        if let user = Auth.auth().currentUser {
            // The user's ID, unique to the Firebase project.
            let uid = user.uid
         
            //access the database to get other user info
            let currentUser = Firestore.firestore().collection("users").document(uid)
            
            Auth.auth().signIn(withEmail: email, password: password){ result, error  in
                if let error = error {
                    print("email: \(email) and password: \(password)")
                    print("Sign in error: \(error.localizedDescription)")
                } else {
                    user.updateEmail(to: newEmail){ error in
                        if let error = error {
                            print("Update error: \(error.localizedDescription)")
                        }else{
                            currentUser.updateData(["email": newEmail])
                        }
                    }
                }
            }
        }
        objectWillChange.send()
    }
    
    func updatePassword(email: String, password: String, newPassword: String){
        if let user = Auth.auth().currentUser {
            // The user's ID, unique to the Firebase project.
            let uid = user.uid
            
            //access the database to get other user info
            let currentUser = Firestore.firestore().collection("users").document(uid)
            
            Auth.auth().signIn(withEmail: email, password: password){ result, error  in
                if let error = error {
                    print("email: \(email) and password: \(password)")
                    print("Sign in error: \(error.localizedDescription)")
                } else {
                    user.updatePassword(to: newPassword){ error in
                        if let error = error {
                            print("Update error: \(error.localizedDescription)")
                        }else{
                            currentUser.updateData(["password": newPassword])
                        }
                    }
                }
            }
        }
        objectWillChange.send()
    }

}
