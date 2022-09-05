//
//  Fire_ToDoApp.swift
//  Fire ToDo
//
//  Created by Fahim Rahman on 22/8/22.
//

import SwiftUI
import FirebaseCore

@main
struct Fire_ToDoApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    init() { FirebaseApp.configure() }
    
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn {
                LoginView()
            }
            else {
                ToDoView()
            }
        }
    }
}
