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
    
    func loadData() {
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
    
    var body: some View {
        Group {
            VStack (alignment: .leading) {
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
                        Text(convertTimestampToPostTime(timestamp: post["date"] as? Int ?? 0))
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
                
                Text(post["text"] as? String ?? "")
                
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
