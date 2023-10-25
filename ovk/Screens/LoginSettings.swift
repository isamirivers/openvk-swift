//
//  LoginSettings.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct LoginSettings: View {
    
    @Binding var debug: Bool
    
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
        }
        .navigationTitle("Настройки")
    }
}
