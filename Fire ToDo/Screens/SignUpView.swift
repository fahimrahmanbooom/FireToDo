//
//  SignUpView.swift
//  Fire ToDo
//
//  Created by Fahim Rahman on 1/9/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @State private var email: String = String()
    @State private var password: String = String()
    @State private var showingAlert = false
    @State private var alertText: String = String()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Sign Up")
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
                
                Button {
                    // login tapped
                    createUser()
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.size.width - 45, height: 55, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange,Color.red]), startPoint: .leading, endPoint: .trailing)
                            .opacity(0.75))
                        .cornerRadius(35)
                } //: button
                .alert("Alert", isPresented: $showingAlert, actions: {}, message: {
                    Text(alertText)
                })
                
                Spacer()
            } //: vstack
            .navigationTitle("")
            .navigationBarHidden(true)
        } //: nav
    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, err in
            if let err = err {
                self.showingAlert = true
                alertText = "SignUp Failed"
                print("Failed due to error:", err)
                return
            }
            self.showingAlert = true
            alertText = "Success! Please Login now"
            print("Successfully created account with ID: \(result?.user.uid ?? "")")
        })
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
