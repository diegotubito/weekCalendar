//
//  LoginView.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewmodel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        TextField("Username", text: $viewmodel.username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        SecureField("Password", text: $viewmodel.password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        Button(action: {
                            Task {
                                await viewmodel.doLogin()
                            }
                        }) {
                            Text("Login")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
            }
            .alert(isPresented: $viewmodel.showAlert) {
                Alert(title: Text(viewmodel.alertTitle),
                      message: Text(viewmodel.alertMessage),
                      dismissButton: .default(Text(viewmodel.alertButtonTitle)))
            }
            .navigationTitle("Login")
        }
        .onChange(of: viewmodel.onLoginSuccess) { success in
            if success {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
