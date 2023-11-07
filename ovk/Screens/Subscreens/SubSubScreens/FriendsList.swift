//
//  FriendsList.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 07.11.2023.
//

import SwiftUI

struct FriendsList: View {
    
    @Binding var debug: Bool
    @Binding var isMainViewUpdated: Bool
    @State var profileHeader: String
    
    @Binding var userIDtoGet: String
    @Binding var friends: [[String: Any]]
    @State var errors: [Int:String] = [:]
    @State var offset = 0
    @State var loadingFinished = false
    
    func findElementByID(idToFind:Int) -> Int? {
        if let index = friends.firstIndex(where: { ($0["id"] as? Int) == idToFind }) {
            return index
        }
        return nil
    }
    
    func loadFriendsData() {
        for friend in friends {
            if friend["photo_50"] == nil {
                let friendID = String(friend["id"] as? Int ?? -1)
                CallAPI(function: "Users.get", params: ["fields": "photo_50,status,verified", "user_ids": friendID], completion: afterLoadFriendsData)
            }
        }
    }
                                                    
   func afterLoadFriendsData(data: [String: Any]?) {
       let response = (data?["response"] as? [[String: Any]])?.first
       
       if let index = findElementByID(idToFind: response?["id"] as? Int ?? -1), index >= 0 && index < friends.count {
           friends[index]["photo_50"] = response?["photo_50"]
           friends[index]["status"] = response?["status"]
           friends[index]["verified"] = response?["verified"]
       }
   }
    
    func afterInfiniteScrollLoad(data: [String: Any]?) {
        let response = data?["response"] as? [String: Any]
        if let items = response?["items"] as? [[String: Any]] {
            if items.count == 1 && items.first?["deactivated"] != nil {
                loadingFinished = true
            }
            friends += items
        }
        loadFriendsData()
    }
    
    var body: some View {
        Form {
            ForEach(0..<friends.count, id:\.self) { index in
                if friends[index]["deactivated"] == nil {
                    HStack (spacing: 15) {
                        AsyncImage(url: URL(string: friends[index]["photo_50"] as? String ?? "")) {
                            image in image.resizable().scaledToFill()
                        }
                    placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        VStack (alignment: .leading) {
                            HStack {
                                Text("\(friends[index]["first_name"] as? String ?? "") \(friends[index]["last_name"] as? String ?? "")")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                if ((friends[index]["verified"] as? Int ?? 0) != 0) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            Text("\(friends[index]["status"] as? String ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                    }
                    .background(
                        NavigationLink("", destination: Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: String(friends[index]["id"] as? Int ?? -1)))
                            .opacity(0)
                    )
                }
            }
            if !loadingFinished {
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Загрузка...")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    offset+=1
                    CallAPI(function: "Friends.get", params: ["user_id": userIDtoGet, "count": "11", "offset": String(offset)], completion: afterInfiniteScrollLoad)
                }
            }
        }.navigationTitle("Друзья").onAppear(perform: loadFriendsData)
    }
}
