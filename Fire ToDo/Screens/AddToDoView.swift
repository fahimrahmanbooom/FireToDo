//
//  AddToDoView.swift
//  Fire ToDo
//
//  Created by Fahim Rahman on 3/9/22.
//

import SwiftUI
import Firebase

struct AddToDoView: View {
    
    @Binding var showAddToDoView: Bool
    @FocusState private var istodoTextFocused: Bool
    @State private var todoText: String = String()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                TextField("Enter ToDo Here", text: $todoText)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
                    .padding()
                    .padding(.top, 40)
                    .focused($istodoTextFocused)

                Spacer()
            } //: vstack
            .navigationBarTitle(Text("Add ToDo"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showAddToDoView = false
                addDataToFirestore()
            }) {
                Text("Save and Exit")
                    .foregroundColor(.black)
                    .bold()
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.istodoTextFocused = true
                }
            }
        }
    }
    
    // MARK: firestore functionalities
    
    // add data to firestore
    private func addDataToFirestore() {
        
        if todoText.isEmpty && UserDefaults.standard.string(forKey: "firebaseUserID") == nil { return }
        
        let todoData: [String: Any] = [
            "id": UUID().uuidString,
            "data": todoText
        ]
        
        Firestore.firestore().collection(UserDefaults.standard.string(forKey: "firebaseUserID") ?? "").addDocument(data: todoData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}



struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView(showAddToDoView: .constant(true))
    }
}
