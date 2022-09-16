//
//  ToDoView.swift
//  Fire ToDo
//
//  Created by Fahim Rahman on 1/9/22.
//

import SwiftUI
import Firebase
import SimpleAFLoader

struct ToDoView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool?
    
    @State private var todoModel: [ToDoModel] = []
    @State private var isLoaderVisible: Bool = false
    @State private var showAddToDoView = false
    
    private let customBlue: Color = Color(red: 52/255, green: 152/255, blue: 219/255)
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.size.width / 1.9 , height: 4)
                        .foregroundColor(customBlue)
                    
                    List {
                        ForEach(todoModel) { todo in
                            
                            HStack {
                                
                                Image(systemName: "wrench.and.screwdriver")
                                
                                Text(todo.data)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.8))
                                    .padding([.vertical], 15)
                            } //: hstack
                        } //: for each
                        .onDelete(perform: delete)
                    } //: list
                    .listStyle(PlainListStyle())
                } //: vstack
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            // plus button tapped
                            self.showAddToDoView.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(customBlue)
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                        } //: button
                        .padding()
                        .sheet(isPresented: $showAddToDoView, onDismiss: {
                            self.isLoaderVisible = true
                            fetchDataFromFirestore()
                        }) {
                            AddToDoView(showAddToDoView: self.$showAddToDoView)
                        }
                    } //: hstack
                } //: vstack
            } //: zstack
            .overlay(LoaderView(loaderColor: .black, loaderTextColor: .black, loadingText: "Getting Data", loaderElementSize: .medium, loaderAnimationSpeed: .high, showLoader: isLoaderVisible))
            .disabled(isLoaderVisible)
            .navigationTitle("MY LIST")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button(action: {
                self.isLoggedIn = false
            }) {
                Text("Logout")
                    .foregroundColor(customBlue)
                    .bold()
            })
        } //: nav view
        .onAppear {
            self.isLoaderVisible = true
            fetchDataFromFirestore()
        } //: on appear
    }
    
    
    // MARK: - list functionalities
    
    private func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        deleteSingleDataFromFirestore(id: todoModel[index].id, completion: { success in
            if success {
                todoModel.remove(atOffsets: offsets)
            }
        })
    }
    
    
    // MARK: - firebase functionalities
    
    // fetch all data
    private func fetchDataFromFirestore() {
        Firestore.firestore().collection(UserDefaults.standard.string(forKey: "firebaseUserID") ?? "").order(by: "data").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    self.todoModel = snapshot.documents.map { document in
                        ToDoModel(id: document.documentID, data: document["data"] as? String ?? "Not Found")
                    }
                    self.isLoaderVisible = false
                }
            }
            else {
                print(error as Any)
            }
        }
    }
    
    // delete data by id
    private func deleteSingleDataFromFirestore(id: String, completion: @escaping (Bool) -> ()) {
        Firestore.firestore().collection(UserDefaults.standard.string(forKey: "firebaseUserID") ?? "").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(false)
            } else {
                print("Document successfully removed!")
                completion(true)
            }
        }
    }
}


struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
