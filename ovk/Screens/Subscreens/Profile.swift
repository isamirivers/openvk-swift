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
    @Binding var profileHeader: String
    
    @State var error = false
    @State var error_reason = ""
    
    @State var jsonData = [:]
    @State var profileImage = ""
    @State var first_name = ""
    @State var last_name = ""
    @State var name = getLocalizedString(key: "Loading...")
    @State var online = 0
    @State var platform = 1
    @State var sex = 0
    @State var last_seen_object = [:]
    @State var last_seen = getLocalizedString(key: "Никогда")
    @State var status = ""
    
    @State var userIDtoGet: String
    
    func clearProfileVariables() {
        profileImage = ""
        first_name = ""
        last_name = ""
        name = getLocalizedString(key: "Loading...")
        online = 0
        platform = 1
        sex = 0
        last_seen_object = [:]
        last_seen = getLocalizedString(key: "Никогда")
        status = ""
    }
    
    func getPlatform(platform_integer: Int) -> String {
        switch (platform_integer) {
        case 2:
            return "\(getLocalizedString(key: "from")) iPhone"
        case 4:
            return "\(getLocalizedString(key: "from")) Android"
        case 7:
            return ""
        default:
            return "\(getLocalizedString(key: "from")) API"
        }
    }
    
    func loadProfileData() {
        CallAPI(function: "Users.get", params: ["fields": "status,photo_200,last_seen,online,sex,music,movies,tv,books,city,interests", "user_ids": userIDtoGet], completion: afterProfileDataLoad)
    }
    
    func afterProfileDataLoad(data: [String: Any]?) {
        if (data?["error_msg"] != nil) {
            error = true
            error_reason = data!["error_msg"] as! String
        }
        clearProfileVariables()
        if let responseArray = data?["response"] as? [[String: Any]] {
            let userInfo = responseArray.first
            jsonData = userInfo ?? [:]
            first_name = userInfo?["first_name"] as? String ?? "Error"
            if jsonData.isEmpty {
                return
            }
            last_name = userInfo?["last_name"] as? String ?? ""
            name = "\(first_name) \(last_name)"
            profileHeader = name
            last_seen_object = userInfo?["last_seen"] as? [AnyHashable : Any] ?? ["platform": 1, "time": 0]
            online = userInfo?["online"] as? Int ?? 0
            platform = last_seen_object["platform"] as? Int ?? 1
            if (online == 0) {
                if last_seen_object["time"] as? Int != 0 {
                    last_seen = "\(convertTimestampToStatus(last_seen_object["time"] as! Int, sex: sex)) \(getPlatform(platform_integer: platform))"
                }
            } else {
                last_seen = "\(getLocalizedString(key: "online").capitalizedSentence) \(getPlatform(platform_integer: platform))"
            }
            status = userInfo?["status"] as? String ?? ""
            profileImage = userInfo?["photo_200"] as? String ?? ""
        }
    }
    
    var body: some View {
        Form {
            if !error {
                if debug {
                    Section {
                        Text(String(describing: jsonData))
                    } header: {
                        Text("Debug")
                    }
                    Section {
                        TextField("ID", text: $userIDtoGet)
                        Button ("Получить") {
                            loadProfileData()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } header: {
                        Text("Получить профиль другого пользователя")
                    }
                }
                
                Section {
                    HStack (alignment: .top, spacing: 20) {
                        AsyncImage(url: URL(string: profileImage)) { image in image.resizable().scaledToFill() }
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
                                .foregroundColor((online != 0) ? .primary : .secondary)
                            Spacer()
                                .frame(height: 15)
                            Text(status)
                                .font(.callout)
                        }
                        .frame(alignment: .leading)
                        
                    }
                    Button("Показать информацию") {}
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                
                Section {
                    NavigationLink(destination: About()) {
                        HStack {
                            Text("Друзья")
                            Spacer()
                            Text("nil")
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink(destination: About()) {
                        HStack {
                            Text("Подписчики")
                            Spacer()
                            Text("nil")
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink(destination: About()) {
                        HStack {
                            Text("Группы")
                            Spacer()
                            Text("nil")
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink(destination: About()) {
                        HStack {
                            Text("Альбомы")
                            Spacer()
                            Text("nil")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                
                Section {
                    Group {
                        VStack (alignment: .leading) {
                            HStack (spacing: 15) {
                                AsyncImage(url: URL(string: profileImage)) { image in image.resizable().scaledToFill() }
                            placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                VStack (alignment: .leading) {
                                    Text("Isami Barinova")
                                        .font(.headline)
                                    Text("26 Sep at 11:08")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button (action: {}) {
                                    Image(systemName: "ellipsis")
                                        .imageScale(.large)
                                        .padding(5)
                                }
                                .foregroundColor(.secondary)
                            }
                            Spacer()
                                .frame(height: 10)
                            
                            Text("Остались ещё люди в этом мире у которых нет телеграм шитпоста?")
                            
                            Spacer()
                                .frame(height: 10)
                            
                            HStack {
                                Button (action: {}) {
                                    Image(systemName: "arrowshape.turn.up.forward")
                                        .imageScale(.large)
                                        .padding(5)
                                }
                                .foregroundColor(.secondary)
                                
                                Spacer()
                                Button (action: {}) {
                                    HStack (spacing: 2) {
                                        Image(systemName: "bubble")
                                            .imageScale(.large)
                                            .padding(5)
                                        Text("1")
                                    }
                                }
                                .foregroundColor(.secondary)
                                
                                Button (action: {}) {
                                    HStack (spacing: 2) {
                                        Image(systemName: "heart")
                                            .imageScale(.large)
                                            .padding(5)
                                        Text("1")
                                    }
                                }
                                .foregroundColor(.secondary)
                            }
                        }
                        
                        
                        .padding([.top, .bottom], 10)
                    }
                } header: {
                    Text("Посты")
                }
            }
            else {
                Text("Произошла ошибка загрузки профиля: \(error_reason)")
                Button("Повторить попытку") {
                    loadProfileData()
                }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear(perform: loadProfileData)
    }
}

#Preview {
    MainView()
}
