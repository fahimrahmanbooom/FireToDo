//
//  LoginView.swift
//  Fire ToDo
//
//  Created by Fahim Rahman on 31/8/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool?
    
    @State private var email: String = String()
    @State private var password: String = String()
    @State private var showingAlert = false
    @State private var alertText: String = String()
    @State private var navigatingToToDoView = false
    @State private var navigateToSignUpView = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                Text("Login")
                    .foregroundColor(.black)
                    .opacity(0.69)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .padding()
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.size.width - 45, height: 55, alignment: .leading)
                        .background(.black).opacity(0.07)
                        .cornerRadius(35)
                    
                    Image(systemName: "person")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.5))
                        .offset(x: 15)
                    
                    if email.isEmpty {
                        Text("Email")
                            .offset(x: 45)
                            .foregroundColor(.black.opacity(0.5))
                            .font(.system(size: 20))
                            .frame(height: 50, alignment: .leading)
                    }
                    TextField("", text: $email)
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                        .frame(width: UIScreen.main.bounds.size.width - 100, height: 55)
                        .offset(x: 45)
                } //: zstack
                .padding([.leading, .trailing], 20)
                .padding(.bottom)
                
                ZStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(height: 55, alignment: .leading)
                        .background(.black).opacity(0.07)
                        .cornerRadius(35)
                    
                    Image(systemName: "lock")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.5))
                        .offset(x: 15)
                    
                    if password.isEmpty {
                        Text("Password")
                            .offset(x: 45)
                            .foregroundColor(.black.opacity(0.5))
                            .font(.system(size: 20))
                            .frame(width: UIScreen.main.bounds.size.width - 45, height: 55, alignment: .leading)
                    }
                    SecureField("", text: $password)
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                        .frame(width: UIScreen.main.bounds.size.width - 100, height: 55)
                        .offset(x: 45)
                } //: zstack
                .padding([.leading, .trailing], 20)
                
                Spacer()
                
                NavigationLink(destination: ToDoView(), isActive: $navigatingToToDoView) {
                    Button {
                        // login tapped
                        loginUser()
                    } label: {
                        Text("Login")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.size.width - 45, height: 55, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange,Color.red]), startPoint: .leading, endPoint: .trailing)
                                .opacity(0.75))
                            .cornerRadius(35)
                    } //: button
                }
                .alert("Alert", isPresented: $showingAlert, actions: {}, message: {
                    Text(alertText)
                })
                
                Spacer()
                
                HStack {
                    Text("Not a member?")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.69))
                    
                    NavigationLink(destination: SignUpView(), isActive: $navigateToSignUpView) {
                        Button {
                            self.navigateToSignUpView = true
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.indigo)
                        }
                    } //: button
                } //: hstack
            } //: vstack
            .navigationTitle("")
            .navigationBarHidden(true)
        } //: nav
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                self.showingAlert.toggle()
                print("Failed due to error:", err)
                alertText = "Login Failed"
                return
            }
            self.isLoggedIn = true
            self.navigatingToToDoView = true
            UserDefaults.standard.set(result?.user.uid, forKey: "firebaseUserID")
            print("Successfully logged in with ID: \(result?.user.uid ?? "")")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
