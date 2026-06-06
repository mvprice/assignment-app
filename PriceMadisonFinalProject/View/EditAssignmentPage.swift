//
//  EditAssignmentPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/6/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditAssignmentPage: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    
    private var assignment: Assignment?
    private var user: User?
    
    @State private var title = ""
    @State private var dueDate = ""
    @State private var className = ""
    @State private var notes = ""
    @State private var completed = false
    @State private var userId = ""
    
    @State var toAssignments = false
    
    init(assignment: Assignment? = nil, user: User? = nil){
        if let assignment, let user{
            self.assignment = assignment
            _title = State(initialValue: assignment.title)
            _dueDate = State(initialValue: assignment.dueDate)
            _className = State(initialValue: assignment.className)
            _completed = State(initialValue: assignment.completed)
            _notes = State(initialValue: assignment.notes)
            _userId = State(initialValue: user.id)
        }
    }
    
    var body: some View {
            VStack{
                HStack{
                    Text(assignment != nil ? "Assignment Details" : "New Assignment")
                        .font(Font.custom("BebasNeue-Regular", size: 60))
                        .padding([.leading], 20)
                        .foregroundStyle(pink)
                    Spacer()
                }
                
                if assignment != nil {
                    HStack{
                        VStack{
                            Text("Title:")
                                .font(Font.custom("BebasNeue-Regular", size: 40))
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                            Text(title)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .padding([.leading], 20)
                            
                            Text("Due date:")
                                .font(Font.custom("BebasNeue-Regular", size: 40))
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                            Text(dueDate)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .padding([.leading], 20)
                            
                            Text("Class name:")
                                .font(Font.custom("BebasNeue-Regular", size: 40))
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                            Text(className)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .padding([.leading], 20)
                            
                            Text("Notes:")
                                .font(Font.custom("BebasNeue-Regular", size: 40))
                                .padding([.leading], 20)
                                .foregroundStyle(pink)
                            Text(notes)
                                .font(Font.custom("RobotoCondensed", size: 30))
                                .padding([.leading], 20)
                            
                            HStack{
                                Text("Completed:")
                                    .font(Font.custom("BebasNeue-Regular", size: 40))
                                    .padding([.leading], 20)
                                    .foregroundStyle(pink)
                                Spacer()
                                Image(systemName: completed ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 20)
                            }
                        }
                        Spacer()
                    }
                }else{
                    
                    TextField("Title", text: $title)
                        .padding(12.0)
                        .background(Color.white)
                    TextField("Due date: mm/dd/yy", text: $dueDate)
                        .padding(12.0)
                        .background(Color.white)
                    TextField("Class name?", text: $className)
                        .padding(12.0)
                        .background(Color.white)
                    TextField("Notes...", text: $notes)
                        .padding(12.0)
                        .background(Color.white)
                    Toggle("Completed?", isOn: $completed)
                        .padding(12.0)
                        .background(Color.white)
                }
                
                Spacer()
            }
            .padding()
            .toolbar{
                Button("Save"){
                    print("save button pressed")
                    if let assignment {
                        //will not reach
                        dismiss()
                    }else{
                        let newAssignment = Assignment(id: UUID().uuidString, title: title, dueDate: dueDate, className: className, completed: completed, notes: notes, userId: userId)
                        assignmentViewModel.append(assignment: newAssignment)
                        addToDb(assignment: newAssignment)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || dueDate.isEmpty || className.isEmpty || notes.isEmpty)
                .tint(pink)
            }
            .tint(pink)
            .background(yellow)
            .navigationDestination(isPresented: $toAssignments) {
                AssignmentsPage()
                    .navigationBarBackButtonHidden(true)
            }
    }
}

func addToDb(assignment: Assignment){
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    let assignment: [String: Any] = ["title" : assignment.title, "dueDate": assignment.dueDate, "className": assignment.className, "completed": assignment.completed, "notes": assignment.notes, "userId": user?.uid ?? ""]
    
    db.collection("assignments").addDocument(data: assignment){error in
        if let error = error{
            print(error)
        }
    }//please work omg
}

#Preview {
    EditAssignmentPage()
        .environmentObject(AssignmentViewModel())
        .environmentObject(UserViewModel())
}
