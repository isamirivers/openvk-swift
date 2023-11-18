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
    
    @State var user_info: Dictionary<String, Any> = [:]
    
    @State var attachments: [Dictionary<String, Any>] = []
    
    @Binding var imageURL: String
    @Binding var viewerShown: Bool
    
    func loadData() {
        attachments = post["attachments"] as! [Dictionary<String, Any>]
        user_info = getUserById(id: post["from_id"] as? Int ?? -1) ?? [:]
    }
    
    func getUserById(id: Int) -> [String: Any]? {
        for object in profiles {
            if let objectId = object["id"] as? Int, objectId == id {
                return object
            }
        }
        return nil
    }
    
    func tempfunc(post:Dictionary<String, Any>, size:Int=0, image_index:Int=0) -> String {
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
    
    var body: some View {
        Group {
            VStack (alignment: .leading) {
                
                // Аватарка, имя и дата
                HStack (spacing: 15) {
                    AsyncImage(url: URL(string: user_info["photo_50"] as? String ?? "")) { image in image.resizable().scaledToFill() }
                placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    VStack (alignment: .leading) {
                        Text("\(user_info["first_name"] as? String ?? "Ошибка") \(user_info["last_name"] as? String ?? "")")
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
                        imageURL = tempfunc(post: post, size: 10)
                        viewerShown = true
                    }) {
                        AsyncImage(url: URL(string: tempfunc(post: post, size: 10))) { image in image.resizable().scaledToFill() }
                        placeholder: {
                            AsyncImage(url: URL(string: tempfunc(post: post))) { image in image.resizable().scaledToFill() }
                        placeholder: {
                            ProgressView()
                        }.cornerRadius(10)
                        }.cornerRadius(10)
                    }
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
                                        imageURL = tempfunc(post: post, size: 10, image_index: index)
                                        viewerShown = true
                                    }) {
                                        AsyncImage(url: URL(string: tempfunc(post: post, size: 10, image_index: index))) { image in image.resizable().scaledToFill().frame(width: 100, height: 100) }
                                        placeholder: {
                                            AsyncImage(url: URL(string: tempfunc(post: post, size: 0, image_index: index))) { image in image.resizable().scaledToFill().frame(width: 100, height: 100) }
                                            placeholder: {
                                                ProgressView()
                                            }.cornerRadius(10).frame(width: 100, height: 100)
                                        }.cornerRadius(10).frame(width: 100, height: 100)
                                    }
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
