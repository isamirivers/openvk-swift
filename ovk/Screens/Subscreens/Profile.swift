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
    
    @State var loadEnded = false
    
    @State var isMoreInfoPopupOpened = false
    
    @State var postsLoadingFinished = false
    @State var postsOffset = 1
    
    @State var error = false
    @State var errorReason = ""
    
    @State var jsonData = [:]
    @State var profileImage = ""
    @State var first_name = ""
    @State var last_name = ""
    @State var name = getLocalizedString(key: "Loading...")
    @State var online = 0
    @State var platform = 1
    @State var sex = 0
    @State var lastSeenObject = [:]
    @State var lastSeen = ""
    @State var status = ""
    @State var verified = 0
    
    @State var music = ""
    @State var movies = ""
    @State var tv = ""
    @State var books = ""
    @State var city = ""
    @State var interests = ""
    @State var about = ""
    @State var email = ""
    @State var quotes = ""
    @State var telegram = ""
    
    @State var posts = []
    @State var postsProfiles = []
    
    @State var counts = [
        "friends": "",
        "followers": "",
        "groups": "",
        "albums": ""
    ]
    
    @State var friends: [[String: Any]] = [[:]]
    
    @State var userIDtoGet: String
    
    @Binding var imageURL: String
    @Binding var viewerShown: Bool
    
    func clearProfileVariables() {
        isMoreInfoPopupOpened = false
        error = false
        errorReason = ""
        
        jsonData = [:]
        profileImage = ""
        first_name = ""
        last_name = ""
        name = getLocalizedString(key: "Loading...")
        online = 0
        platform = 1
        sex = 0
        lastSeenObject = [:]
        lastSeen = ""
        status = ""
        verified = 0
        
        music = ""
        movies = ""
        tv = ""
        books = ""
        city = ""
        interests = ""
        about = ""
        email = ""
        quotes = ""
        telegram = ""
        
        posts = []
        postsProfiles = []
        
        counts = [
            "friends": "",
            "followers": "",
            "groups": "",
            "albums": ""
        ]
        
        friends = [[:]]
        
        postsLoadingFinished = false
        postsOffset = 1
        
    }
    
    func refresh() {
        loadEnded = false
        clearProfileVariables()
        loadProfileData()
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
        profileHeader = name
        if !loadEnded {
            CallAPI(function: "Account.getProfileInfo", completion: afterGetProfileInfoLoad)
        }
    }
    
    func afterGetProfileInfoLoad(data: [String: Any]?) {
        if (data?["error_msg"] != nil) {
            error = true
            errorReason = data!["error_msg"] as! String
        }
        error = false
        
        let response = data?["response"] as? [String: Any]
        if userIDtoGet == "0" {
            userIDtoGet = String(response?["id"] as? Int ?? 0)
            if userIDtoGet == "0" {
                error = true
                errorReason = "Ошибка загрузки ID"
            }
        }
        
        CallAPI(function: "Users.get", params: ["fields": "status,photo_200,last_seen,online,sex,music,movies,tv,books,city,interests,verified,about,email,quotes,telegram", "user_ids": userIDtoGet], completion: afterProfileDataLoad)
        CallAPI(function: "Friends.get", params: ["user_id": userIDtoGet, "count": "11"], completion: afterFriendsGetLoad)
        CallAPI(function: "Users.getFollowers", params: ["user_id": userIDtoGet, "count": "11"], completion: afterFollowersGetLoad)
        CallAPI(function: "Groups.get", params: ["user_id": userIDtoGet], completion: afterGroupsGetLoad)
        CallAPI(function: "Photos.getAlbums", params: ["owner_id": userIDtoGet], completion: afterAlbumsGetLoad)
        CallAPI(function: "Wall.get", params: ["owner_id": userIDtoGet, "extended": "1", "count": "5"], completion: afterPostsGetLoad)
    }
    
    func afterProfileDataLoad(data: [String: Any]?) {
        if (data?["error_msg"] != nil) {
            error = true
            errorReason = data!["error_msg"] as! String
        }
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
            lastSeenObject = userInfo?["last_seen"] as? [AnyHashable : Any] ?? ["platform": 1, "time": 0]
            online = userInfo?["online"] as? Int ?? 0
            platform = lastSeenObject["platform"] as? Int ?? 1
            sex = userInfo?["sex"] as? Int ?? 0
            if (online == 0) {
                if lastSeenObject["time"] as? Int != 0 {
                    lastSeen = "\(convertTimestampToStatus(lastSeenObject["time"] as! Int, sex: sex)) \(getPlatform(platform_integer: platform))"
                } else {
                    lastSeen = getLocalizedString(key: "Никогда")
                }
            } else {
                lastSeen = "\(getLocalizedString(key: "online").capitalizedSentence) \(getPlatform(platform_integer: platform))"
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
            email = userInfo?["email"] as? String ?? ""
            telegram = userInfo?["telegram"] as? String ?? ""
            quotes = userInfo?["quotes"] as? String ?? ""
            about = userInfo?["about"] as? String ?? ""
            
            loadEnded = true
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
    
    func afterPostsGetLoad(data: [String: Any]?) {
        let response = data?["response"] as? [String: Any]
        posts = response?["items"] as? [Any] ?? []
        postsProfiles = response?["profiles"] as? [Any] ?? []
    }
    
    func afterAdditionalPostsGetLoad(data: [String: Any]?) {
        let response = data?["response"] as? [String: Any]
        let postsObj = response?["items"] as? [Any] ?? []
        if postsObj.count == 0 {
            postsLoadingFinished = true
        }
        posts += postsObj
        postsProfiles += response?["profiles"] as? [Any] ?? []
    }
    
    var body: some View {
        Form {
            if !error {
                if debug {
                    Section {
                        Text("User ID:")
                        TextField("ID", text: $userIDtoGet)
                        Button ("Получить/обновить страницу") {
                            refresh()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        Text("Sex: \(sex)")
                    } header: {
                        Text("Debug")
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
                            Text(lastSeen)
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
                    NavigationLink(destination: FriendsList(refresh: refresh, debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: "", userIDtoGet: $userIDtoGet, friends: $friends, imageURL: $imageURL, viewerShown: $viewerShown)) {
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
                    ForEach(0..<posts.count, id:\.self) {index in
                        Post(
                            post: posts[index] as! Dictionary<String, Any>,
                            profiles: postsProfiles as! [Dictionary<String, Any>],
                            imageURL: $imageURL,
                            viewerShown: $viewerShown
                        )
                    }
                    if !postsLoadingFinished && posts.count > 0 {
                        HStack(spacing: 10) {
                            ProgressView()
                            Text("Загрузка...")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear {
                            postsOffset+=5
                            CallAPI(function: "Wall.get", params: ["owner_id": userIDtoGet, "extended": "1", "count": "5", "offset": String(postsOffset)], completion: afterAdditionalPostsGetLoad)
                        }
                    }
                } header: {
                    if (posts.count > 0) {
                        Text("Посты")
                    }
                }
                .sheet(isPresented: $isMoreInfoPopupOpened, content: {
                    NavigationStack {
                        UserInfoPopup(sex: $sex, music: $music, movies: $movies, tv: $tv, books: $books, city: $city, interests: $interests, quotes: $quotes, email: $email, telegram: $telegram, about: $about)
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
                            loadEnded = false
                            loadProfileData()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } header: {
                        Text("Получить профиль другого пользователя")
                    }
                }
                Text("Произошла ошибка загрузки профиля: \(errorReason)")
                Button("Повторить попытку") {
                    loadProfileData()
                }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(name)
        .refreshable {
            refresh()
        }
        .onAppear(perform: loadProfileData)
    }
}

#Preview {
    MainView()
}
