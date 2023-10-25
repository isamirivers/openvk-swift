//
//  Profile.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct Profile: View {
    
    @Binding var debug: Bool
    
    @Binding var isMainViewUpdated: Bool
    
    @State var jsonData = [:]
    @State var profileImage = ""
    @State var name = "Загрузка..."
    @State var status = ""
    
    func loadData() {
        func afterLoad(data: [String: Any]?) {
            // i finished here
        }
        CallAPI(function: "Users.get", params: ["fields": ""], completion: afterLoad)
    }
    
    var body: some View {
        Form {
            if debug {
                Text(String(describing: jsonData))
            }
            HStack (alignment: .top, spacing: 20) {
                AsyncImage(url: URL(string: profileImage)) { image in image.resizable().scaledToFit() }
            placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                VStack (alignment: .leading) {
                    Text(name)
                        .font(.headline)
                    Text("")
                        .font(.subheadline)
                    Spacer()
                        .frame(height: 15)
                    Text(status)
                        .font(.callout)
                }
                .frame(alignment: .leading)
                
            }
            Button("Выйти") {
                if deleteValueFromKeychain(forKey: "token") {
                    isMainViewUpdated.toggle()
                }
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear(perform: loadData)
    }
}

#Preview {
    MainView()
}
