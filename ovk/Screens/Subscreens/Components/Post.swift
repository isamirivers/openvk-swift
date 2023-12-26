//
//  Post.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 10.11.2023.
//

import SwiftUI

struct Post: View {
    
    @State var post: Dictionary<String, Any>
    @State var profiles: [Dictionary<String, Any>]
    @State var groups: [Dictionary<String, Any>] = []
    
    @State var userOrGroupInfo: Dictionary<String, Any> = [:]
    
    @State var attachments: [Dictionary<String, Any>] = []
    
    @Binding var imageURL: String
    @Binding var viewerShown: Bool
    
    func loadData() {
        attachments = post["attachments"] as! [Dictionary<String, Any>]
        userOrGroupInfo = getUserOrGroupById(id: post["from_id"] as? Int ?? -1) ?? [:]
    }
    
    func getUserOrGroupById(id: Int) -> [String: Any]? {
        var listToSearchIn:[Dictionary<String, Any>] = []
        var fromId = id
        var isGroup = false
        if id < 0 {
            listToSearchIn = groups
            fromId = abs(id)
            isGroup = true
        } else {
            listToSearchIn = profiles
        }
        for var object in listToSearchIn {
            if let objectId = object["id"] as? Int, objectId == fromId {
                object["is_group"] = isGroup
                return object
            }
        }
        return nil
    }
    
    func getImage(post:Dictionary<String, Any>, size:Int=0, image_index:Int=0) -> String {
        if let attachments = post["attachments"] as? [[String: Any]] {
            if attachments.indices.contains(image_index) {
                let photo_object = attachments[image_index]
                let photo = photo_object["photo"] as? [String: Any]
                let sizes = photo?["sizes"] as? [[String: Any]]
                let size_object = sizes?[size] as? [String: Any]
                let url = size_object?["url"] as? String ?? ""
                return url
            }
        }
        return ""
    }
    
    func getUserOrGroupName(userOrGroupInfo:Dictionary<String, Any>) -> String {
        if userOrGroupInfo["is_group"] as? Bool ?? false {
            return userOrGroupInfo["name"] as? String ?? "Ошибка"
        } else {
            return userOrGroupInfo["first_name"] as? String ?? "Ошибка"
        }
    }
    
    var body: some View {
        Group {
            VStack (alignment: .leading) {
                
                // Аватарка, имя и дата
                HStack (spacing: 15) {
                    AsyncImage(url: URL(string: userOrGroupInfo["photo_50"] as? String ?? "")) { image in image.resizable().scaledToFill() }
                placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    VStack (alignment: .leading) {
                        Text("\(getUserOrGroupName(userOrGroupInfo: userOrGroupInfo)) \(userOrGroupInfo["last_name"] as? String ?? "")")
                            .font(.headline)
                            .lineLimit(1)
                        Text(convertTimestampToPostTime(timestamp: post["date"] as? Int ?? 0))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
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
                
                // Текст
                if post["text"] as! String != "" {
                    Text(post["text"] as? String ?? "")
                }
                
                // Фотография
                if ((attachments.first?["type"] as? String) == "photo" && attachments.count < 2)
                || (attachments.indices.contains(1) && (attachments.first?["type"] as? String) == "photo" && (attachments[1]["type"] as? String) != "photo") {
                    Button(action: {
                        imageURL = getImage(post: post, size: 10)
                        viewerShown = true
                    }) {
                        AsyncImage(url: URL(string: getImage(post: post, size: 10))) { image in image.resizable().scaledToFill() }
                        placeholder: {
                            AsyncImage(url: URL(string: getImage(post: post))) { image in image.resizable().scaledToFill() }
                        placeholder: {
                            ProgressView()
                        }.cornerRadius(10)
                        }.cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // Фотографии
                if attachments.indices.contains(1) && attachments[1]["type"] as? String == "photo" {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]) {
                        ForEach(0..<attachments.count, id:\.self) {index in
                            if (attachments.indices.contains(index)) {
                                if (attachments[index]["type"] as? String) == "photo" {
                                    Button(action: {
                                        print("Бутон нажат с индексом \(index)")
                                        imageURL = getImage(post: post, size: 10, image_index: index)
                                        print(imageURL + "\n-----")
                                        viewerShown = true
                                    }) {
                                        AsyncImage(url: URL(string: getImage(post: post, size: 10, image_index: index))) { image in image.resizable().scaledToFill().frame(width: 100, height: 100) }
                                        placeholder: {
                                            AsyncImage(url: URL(string: getImage(post: post, size: 0, image_index: index))) { image in image.resizable().scaledToFill().frame(width: 100, height: 100) }
                                            placeholder: {
                                                ProgressView()
                                            }.cornerRadius(10).frame(width: 100, height: 100)
                                        }.cornerRadius(10).frame(width: 100, height: 100)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                }
                
                // Опросы
                ForEach(0..<attachments.count, id:\.self) {index in
                    if (attachments.indices.contains(index)) {
                        if (attachments[index]["type"] as? String) == "video" {
                            if post["text"] as! String != "" {
                                Spacer()
                            }
                            Text("Прикреплено видео: \((attachments[index]["video"] as? [String:Any])?["title"] as? String ?? "Без названия")")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Опросы
                ForEach(0..<attachments.count, id:\.self) {index in
                    if (attachments.indices.contains(index)) {
                        if (attachments[index]["type"] as? String) == "poll" {
                            if post["text"] as! String != "" {
                                Spacer()
                            }
                            Text("Прикреплён опрос: \((attachments[index]["poll"] as? [String:Any])?["question"] as? String ?? "Неизвестный")")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Аудиозаписи
                ForEach(0..<attachments.count, id:\.self) {index in
                    if (attachments.indices.contains(index)) {
                        if (attachments[index]["type"] as? String) == "audio" {
                            if post["text"] as! String != "" {
                                Spacer()
                            }
                            Text("Прикреплено аудио: \((attachments[index]["audio"] as? [String:Any])?["title"] as? String ?? "Без названия") - \((attachments[index]["audio"] as? [String:Any])?["artist"] as? String ?? "Неизвестен")")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Кнопки снизу поста
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
        }.onAppear(perform: loadData)
    }
}

#Preview {
    MainView()
}
