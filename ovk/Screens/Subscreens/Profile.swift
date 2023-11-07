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
    
    @State var isMoreInfoPopupOpened = false
    
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
    @State var last_seen = ""
    @State var status = ""
    @State var verified = 0
    
    @State var music = ""
    @State var movies = ""
    @State var tv = ""
    @State var books = ""
    @State var city = ""
    @State var interests = ""
    
    @State var counts = [
        "friends": "",
        "followers": "",
        "groups": "",
        "albums": ""
    ]
    
    @State var friends: [[String: Any]] = [[:]]
    
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
        last_seen = ""
        
        status = ""
        verified = 0
        music = ""
        movies = ""
        tv = ""
        books = ""
        city = ""
        interests = ""
        
        counts = [
            "friends": "",
            "followers": "",
            "groups": "",
            "albums": ""
        ]
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
        profileHeader = ""
        
        CallAPI(function: "Account.getProfileInfo", completion: afterGetProfileInfoLoad)
        CallAPI(function: "Users.get", params: ["fields": "status,photo_200,last_seen,online,sex,music,movies,tv,books,city,interests,verified", "user_ids": userIDtoGet], completion: afterProfileDataLoad)
    }
    
    func afterGetProfileInfoLoad(data: [String: Any]?) {
        if (data?["error_msg"] != nil) {
            error = true
            error_reason = data!["error_msg"] as! String
        }
        
        let response = data?["response"] as? [String: Any]
        if userIDtoGet == "0" {
            userIDtoGet = String(response?["id"] as? Int ?? 0)
        }
        
        CallAPI(function: "Friends.get", params: ["user_id": userIDtoGet, "count": "11"], completion: afterFriendsGetLoad)
        CallAPI(function: "Users.getFollowers", params: ["user_id": userIDtoGet, "count": "11"], completion: afterFollowersGetLoad)
        CallAPI(function: "Groups.get", params: ["user_id": userIDtoGet], completion: afterGroupsGetLoad)
        CallAPI(function: "Photos.getAlbums", params: ["owner_id": userIDtoGet], completion: afterAlbumsGetLoad)
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
                } else {
                    last_seen = getLocalizedString(key: "Никогда")
                }
            } else {
                last_seen = "\(getLocalizedString(key: "online").capitalizedSentence) \(getPlatform(platform_integer: platform))"
            }
            status = userInfo?["status"] as? String ?? ""
            profileImage = userInfo?["photo_200"] as? String ?? ""
            
            status = userInfo?["status"] as? String ?? ""
            verified = userInfo?["verified"] as? Int ?? 0
            music = userInfo?["music"] as? String ?? ""
            movies = userInfo?["movies"] as? String ?? ""
            tv = userInfo?["tv"] as? String ?? ""
            books = userInfo?["books"] as? String ?? ""
            city = userInfo?["city"] as? String ?? ""
            interests = userInfo?["interests"] as? String ?? ""
        }
    }
    
    func setCount(data: [String: Any]?, counterName: String) {
        if (data?["error_msg"] != nil) {
            counts[counterName] = "error"
        }
        let response = data?["response"] as? [String: Any]
        let CountInt = response?["count"] as? Int ?? -1
        if CountInt == -1 {
            counts[counterName] = "error"
        } else {
            counts[counterName] = String(CountInt)
        }
    }
    
    func afterFriendsGetLoad(data: [String: Any]?) {
        setCount(data: data, counterName: "friends")
        
        let response = data?["response"] as? [String: Any]
        friends = response?["items"] as? [[String: Any]] ?? [[:]]
    }
    
    func afterFollowersGetLoad(data: [String: Any]?) {
        setCount(data: data, counterName: "followers")
    }
    
    func afterGroupsGetLoad(data: [String: Any]?) {
        setCount(data: data, counterName: "groups")
    }
    
    func afterAlbumsGetLoad(data: [String: Any]?) {
        setCount(data: data, counterName: "albums")
    }
    
    var body: some View {
        Form {
            if !error {
                if debug {
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
                            HStack {
                                Text(name)
                                    .font(.headline)
                                if (verified != 0) {
                                    Image(systemName: "checkmark")
                                }
                            }
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
                    Button("Показать информацию") {
                        isMoreInfoPopupOpened = true
                    }
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                
                Section {
                    NavigationLink(destination: FriendsList(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: $userIDtoGet, friends: $friends)) {
                        HStack {
                            Text("Друзья")
                            Spacer()
                            if counts["friends"] == "" {ProgressView()}
                            Text(counts["friends"] ?? "error")
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink(destination: About()) {
                        HStack {
                            Text("Подписчики")
                            Spacer()
                            if counts["followers"] == "" {ProgressView()}
                            Text(counts["followers"] ?? "error")
                                .foregroundStyle(.secondary)
                        }
                    }
                    if counts["groups"] != "error" {
                        NavigationLink(destination: About()) {
                            HStack {
                                Text("Группы")
                                Spacer()
                                if counts["groups"] == "" {ProgressView()}
                                Text(counts["groups"] ?? "error")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    if counts["albums"] != "error" {
                        NavigationLink(destination: About()) {
                            HStack {
                                Text("Альбомы")
                                Spacer()
                                if counts["albums"] == "" {ProgressView()}
                                Text(counts["albums"] ?? "error")
                                    .foregroundStyle(.secondary)
                            }
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
                .sheet(isPresented: $isMoreInfoPopupOpened, content: {
                    NavigationStack {
                        UserInfoPopup(music: $music, movies: $movies, tv: $tv, books: $books, city: $city, interests: $interests)
                            .navigationTitle("Информация")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                })
            }
            else {
                if debug {
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
                Text("Произошла ошибка загрузки профиля: \(error_reason)")
                Button("Повторить попытку") {
                    loadProfileData()
                }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(profileHeader)
        .onAppear(perform: loadProfileData)
    }
}

#Preview {
    MainView()
}
