//
//  AssignmentViewModel.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class AssignmentViewModel: ObservableObject{
    @Published var assignments = [Assignment]()
    @Published var currentIndex = 0
    
    init(){
        if let user = Auth.auth().currentUser {
            // The user's ID, unique to the Firebase project.
            let uid = user.uid
            
            //access the database to get other user info
            let assignmentsDoc = Firestore.firestore().collection("assignments")
            
            assignmentsDoc.whereField("userId", isEqualTo: uid).getDocuments() { (query, error) in
                if let error = error{
                    print("Error getting assignments: \(error)")
                }else{
                    for document in query!.documents {
                        if document == document{
                            let assignmentid = document.documentID
                            let assignmentData = document.data()
                            
                            let assignment = Assignment(
                                id: assignmentid,
                                title: assignmentData["title"]as? String ?? "",
                                dueDate: assignmentData["dueDate"]as? String ?? "",
                                className: assignmentData["className"]as? String ?? "",
                                completed: assignmentData["completed"]as? Bool ?? false,
                                notes: assignmentData["notes"]as? String ?? "",
                                userId: uid
                            )
                            self.assignments.append(assignment)
                        }
                        
                    }
                }
            }
        }else{
            assignments.append(Assignment(
                id: UUID().uuidString,
                title: "test",
                dueDate: "test",
                className: "test",
                completed: false,
                notes: "test",
                userId: "1"))
        }
        objectWillChange.send()
    }
    
    
    var numberOfAssignments: Int {
        return assignments.count
    }
    
    var numberComplete: Int{
        let completed = assignments.filter { ($0.completed == true) }
        return completed.count
    }

    // Initializes a assignment at end of your assignments array
    func append(assignment: Assignment){
        assignments.append(assignment)
        objectWillChange.send()
    }

    // Returns an index for a given assignment
    func getIndex(for assignment: Assignment) -> Int?{
        return assignments.firstIndex(of: assignment)
    }

    // Updates a assignment at a specific index
    func update(assignment: Assignment, at index: Int){
        if index >= assignments.count || index < 0 {
            return
        }
        assignments[index] = assignment
        objectWillChange.send()
//        save()
    }

    // Toggles the completed attribute of your assignment
    func toggleCompleted(assignment: Assignment){
        let index = getIndex(for: assignment)!
        let currentID = assignments[currentIndex].id
        let currentTitle = assignments[currentIndex].title
        let currentDueDate = assignments[currentIndex].dueDate
        let currentClassName = assignments[currentIndex].className
        let currentCompleted = assignments[currentIndex].completed
        let currentNotes = assignments[currentIndex].notes
        let currentUserId = assignments[currentIndex].userId
        
        let currentAssignment = Assignment(id: currentID, title: currentTitle, dueDate: currentDueDate, className: currentClassName, completed: !currentCompleted, notes: currentNotes, userId: currentUserId)
        
//        assignments[index] = currentAssignment
        update(assignment: currentAssignment, at: index)
        objectWillChange.send()
    }
    
    func findAssignment(title: String) -> Assignment?{
        for assignment in assignments {
            if assignment.title == title{
                return assignment
            }
        }
        return nil
    }
    
    // Returns an index for a given assignment
    func getIndex(title: String) -> Int?{
        if let assignment = findAssignment(title: title){
            return assignments.firstIndex(of: assignment)
        }
        return 0
    }
    
    // Updates a assignment
    func update(assignment: Assignment){
        if let index = assignments.firstIndex(where: { $0.id == assignment.id }) {
            assignments[index] = assignment
        }
        objectWillChange.send()
        
        Firestore.firestore().collection("assignments").document(assignment.id).updateData([
            "completed": assignment.completed
        ]){error in
            if let error = error{
                print(error)
            }
        }
        objectWillChange.send()
    }
    
}
