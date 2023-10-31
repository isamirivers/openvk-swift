//
//  About.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct About: View {
    var body: some View {
        Form {
            HStack {
                Text("OpenVK Swift")
                Spacer()
                Text((Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/isamirivers/openvk-swift")!) {
                    HStack{
                        Text("Исходный код")
                        Spacer()
                        Text("GitHub")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Ссылки")
            }
            
            Section {
                Link(destination: URL(string: "https://isamiri.ru")!) {
                    HStack{
                        Text("IsamiRi")
                        Spacer()
                        Text("isamiri.ru")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Автор")
            }
        }
        .navigationTitle("О приложении")
    }
}

#Preview {
    About()
}
