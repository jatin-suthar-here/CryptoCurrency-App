//
//  SignupView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import SwiftUI

struct SignupView: View {
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State var shouldSignUp = false
    
    // For redirecting to the 'SignUp' View
    // it will dismiss the top layer of Navigation link...
    // (base layer -> Login View   ;   top layer -> SignUp View)
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthViewModel
    let Screenwidth = (UIScreen.main.bounds.width)/3 - 30
    
    var body: some View {
        VStack {
            // Texts
            VStack {
                HStack {
                    Text("Hi, Welcome.")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Text("Let's get started!")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.top, Screenwidth)
            .padding(.bottom, 30)
            
            
            // Signup Form fields
            VStack (spacing: 13)
            {
                InputView(text: $email, title: "Email Address", placeholder: "name@apple.com")
                    .autocapitalization(.none)
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword, title: "Password", placeholder: "confirm your password", isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty
                    {
                        if password == confirmPassword {
                            Image (systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                                .padding(.top, 25)
                                .padding(.trailing, 5)
                        } else {
                            Image (systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                                .padding(.top, 25)
                                .padding(.trailing, 5)
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            
            if shouldSignUp {
                HStack {
                    Spacer()
                    Text("User already exists, please login.")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .offset(y: 20)
                        .foregroundColor(.red)
                        .padding(.top, -15)
                }
                .padding(.horizontal)
            }
            
            Button {
                Task {
                    // the code is running aysnchronously ( when checkUserExists is in execution while the if-else condition is also running at the same time, but here we have to wait for checkUserExist to complete first then it should move forward )
                    // ..So we are using "withCheckedThrowingContinuation" completion for making it synchoronous.
                    let userExists = await viewModel.checkUserExists(email: email, password: password)
                    if userExists {
                        print("USER EXISTS SO CAN'T DO ANYTHING....")
                        shouldSignUp = true
                    } else {
                        print("USER DON'T EXISTS...")
                        await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                    }
                }
            
            }
            label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width-32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.7)
            .padding(.top, 24)

            
            Spacer()
            
            // Signin Button
            Button {
                // For redirecting to the 'SignUp' View
                dismiss()
                
            }
            label: {
                HStack(spacing: 3)
                {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
                .padding(.bottom, 15)
            }
            
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading))
    }
}

extension SignupView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && email.contains(".")
            && !password.isEmpty
            && password.count > 5
            && confirmPassword == password
            && !fullname.isEmpty
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
