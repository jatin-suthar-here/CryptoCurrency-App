//
//  LoginView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    let Screenwidth = (UIScreen.main.bounds.width)/3 - 30
    
    var body: some View {
        NavigationStack {
            VStack {
                // Texts
                VStack {
                    HStack {
                        Text("Hi, Welcome back!")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack {
                        Text("Access your account.")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.top, Screenwidth)
                .padding(.bottom, 30)
                

                
                // Login Form fields
                VStack (spacing: 15)
                {
                    InputView(text: $email, title: "Email Address", placeholder: "name@apple.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                
                
                // SignIn button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }
                label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width-32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.7)
                .cornerRadius(10)
                .padding(.top, 24)
                
                
                Spacer()
                
                // SignUp button
                NavigationLink {
                    SignupView()
                        .navigationBarBackButtonHidden()
                }
                label: {
                    HStack(spacing: 3)
                    {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 15)
                }
                
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading))

        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && email.contains(".")
            && !password.isEmpty
            && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
