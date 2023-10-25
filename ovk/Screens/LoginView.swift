//
//  ContentView.swift
//  ovk
//
//  Created by Isami Riša on 23.10.2023.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var debug: Bool
    
    @State private var login: String = ""
    @State private var password: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    
    @State private var isLoading: Bool = false
    
    @State private var isWebViewOpened: Bool = false
    @State private var webViewURL: URL =  URL(string: "https://openvk.su/reg")!
    
    @State private var showError: Bool = false
    @State private var errorText: String = ""
    
    @State private var instance = "https://openvk.su"
    
    // Эта хрень обновляет view 👇🏼
    @State private var isViewUpdated = false
    @Binding var isMainViewUpdated: Bool
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                if debug {
                    Section /* DEBUG */ {
                        Text("Keychain token: \(getValueFromKeychain(forKey:"token") ?? "nil")")
                        Button("Удалить токен из связки ключей") {
                            if deleteValueFromKeychain(forKey: "token") {
                                isViewUpdated.toggle()
                            }
                        }
                        .foregroundColor(.red)
                    } header: {
                        Text("Debug")
                    }
                }
                
                
                Section /* Поле ввода инстанса */ {
                    TextField("Адрес", text: $instance)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: login, perform: { value in
                            showError = false
                        })
                } header: {
                    Text("Инстанс")
                }
                
                
                Section /* Поля ввода данных для входа */ {
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
                } header: {
                    Text("Данные для входа")
                } footer: {
                    if showError {
                        Text(errorText)
                            .foregroundColor(Color.red)
                    }
                }
                
                
                Section /* Кнопки войти, зарегистрироваться */ {
                    Button (action:{
                        isLoading = true
                        
                        // 👇🏼 Эта функция вызывается после того как отрабатывает LogIn
                        func completion(response: [String : Any]?) {
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
                                else {
                                    isMainViewUpdated.toggle()
                                    saveValueToUserDefaults(forKey: "instance", value: instance)
                                }
                            }
                            
                        }
                        LogIn(login: login, password: password, instance: instance, completion: completion)
                    }) {
                        HStack(){
                            Text("Войти")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if isLoading {
                                ProgressView()
                            }
                        }
                    }
                    Button("Зарегистрироваться в браузере") {
                        webViewURL = URL(string: "\(instance)/reg")!
                        isWebViewOpened = true
                    }
                    Button("Сбросить пароль") {
                        webViewURL = URL(string: "\(instance)/restore")!
                        isWebViewOpened = true
                    }
                    .sheet(isPresented: $isWebViewOpened, content: {
                        NavigationStack {
                            WebView(url: webViewURL)
                                .navigationTitle("OpenVK")
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    })
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertText))
            })
                // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
                .background(isViewUpdated ? Color.clear : Color.clear)
                .allowsHitTesting(!isLoading)
                .navigationBarTitle("OpenVK Swift")
                .toolbar {
                    NavigationLink (destination: LoginSettings(debug: $debug)) {Image(systemName: "gearshape")}
                }
        }
    }
}

#Preview {
    MainView()
}
