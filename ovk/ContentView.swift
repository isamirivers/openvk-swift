//
//  ContentView.swift
//  ovk
//
//  Created by Isami Riša on 23.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    @State private var isLoading: Bool = false
    @State private var isWebViewOpened: Bool = false
    @State private var showError: Bool = false
    @State private var errorText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Keychain token: \(getValueFromKeychain(forKey:"token") ?? "nil")")
                    Button("Удалить токен из связки ключей") {
                        if deleteValueFromKeychain(forKey: "token") {
                            alertText = "Токен удалён!"
                            showAlert = true
                        }
                    }
                        .foregroundColor(.red)
                }
                Section {
                    TextField("Логин", text: $login)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: login, perform: { value in
                            showError = false
                        })
                    SecureField("Пароль", text: $password)
                        .onChange(of: password, perform: { value in
                            showError = false
                        })
                } footer: {
                    if showError {
                        Text(errorText)
                            .foregroundColor(Color.red)
                    }
                }
                Section {
                    Button("Войти") {
                        isLoading = true
                        func completion(response: [String : Any]?) {
                            alertText = DictToString(from: response!)!
                            showAlert = true
                            isLoading = false
                            if (response!["error_msg"] != nil) {
                                errorText = response!["error_msg"] as! String
                                showError = true
                            }
                            else {
                                if !saveValueToKeychain(forKey: "token", value: response!["access_token"]! as! String) {
                                    errorText = "Токен не может быть сохранён, так как имеется другой"
                                    showError = true
                                }
                            }
                        }
                        LogIn(login: login, password: password, completion: completion)
                    }
                    Button("Зарегистрироваться в браузере") {
                        isWebViewOpened = true
                    }
                    .sheet(isPresented: $isWebViewOpened, content: {
                        NavigationStack {
                            WebView(url: URL(string: "https://openvk.su/reg")!)
                                .navigationTitle("Регистрация")
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    })
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertText))
            })
            .overlay(
                Group {
                    if isLoading {
                        ProgressView() {Text("Вход")}
                            .controlSize(.large)
                    }
                }
            ).allowsHitTesting(!isLoading)
                .navigationBarTitle("OpenVK Swift")
        }
    }
}

#Preview {
    ContentView()
}
