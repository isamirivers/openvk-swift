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
    @State var first_name = ""
    @State var last_name = ""
    @State var name = getLocalizedString(key: "Loading...")
    @State var online = false
    @State var platform = 1
    @State var sex = 0
    @State var last_seen_object = [:]
    @State var last_seen = getLocalizedString(key: "Никогда")
    @State var status = ""
    
    func getPlatform(platform_integer: Int) -> String {
        switch (platform_integer) {
        case 2:
            return "\(getLocalizedString(key: "from")) iPhone"
        case 4:
            return "\(getLocalizedString(key: "from")) Android"
        case 7:
            return "\(getLocalizedString(key: "from")) NULL"
        default:
            return "\(getLocalizedString(key: "from")) API"
        }
    }
    
    func loadData() {
        func afterLoad(data: [String: Any]?) {
            if let responseArray = data?["response"] as? [[String: Any]] {
                let userInfo = responseArray.first
                jsonData = userInfo ?? [:]
                first_name = userInfo!["first_name"] as? String ?? "Error"
                last_name = userInfo!["last_name"] as? String ?? ""
                name = "\(first_name) \(last_name)"
                last_seen_object = userInfo!["last_seen"] as! [AnyHashable : Any]
                online = (userInfo!["online"] != nil)
                platform = userInfo!["platform"] as? Int ?? 1
                if !online {
                    last_seen = "\(convertTimestampToStatus(last_seen_object["time"] as! Int, sex: sex)) \(getPlatform(platform_integer: platform))"
                } else {
                    last_seen = "\(getLocalizedString(key: "online").capitalizedSentence) \(getPlatform(platform_integer: platform))"
                }
                status = userInfo!["status"] as? String ?? ""
                profileImage = userInfo!["photo_200"] as? String ?? ""
            }
        }
        CallAPI(function: "Users.get", params: ["fields": "status,photo_200,last_seen,online,sex"], completion: afterLoad)
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
                    Text(last_seen)
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
