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
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Логин", text: $login)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Пароль", text: $password)
                }
                Section {
                    Button("Войти") {
                        showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Вы ввели \(login)"))
                    }
                }
            }
            .navigationBarTitle("Форма входа")
        }
    }
}

#Preview {
    ContentView()
}
