//
//  LoginSettings.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct LoginSettings: View {
    
    @Binding var debug: Bool
    @Binding var isMainViewUpdated: Bool
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $debug) {
                    Text("Режим разработчика")
                }
                NavigationLink(destination: About()) {
                    Text("О приложении")
                }
            }
            .modifier(FormElevateOnWhiteBackground())
            
            
            Section {
                ForEach(Array(UserDefaults.standard.dictionaryRepresentation().sorted(by: { $0.key < $1.key })), id: \.0) { key, value in
                    HStack {
                        Text(key)
                        Spacer()
                        Text(String(describing: value))
                    }
                }
            } header: {
                Text("UserDefaults")
            }
            .modifier(FormElevateOnWhiteBackground())
            
            
            Section {
                Button("Выйти") {
                    if deleteValueFromKeychain(forKey: "token") {
                        isMainViewUpdated.toggle()
                    }
                }
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .modifier(FormElevateOnWhiteBackground())
        }
        .modifier(FormHiddenBackground())
        .navigationTitle("Настройки")
    }
}
