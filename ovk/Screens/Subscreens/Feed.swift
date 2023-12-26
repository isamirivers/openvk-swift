//
//  Feed.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 01.12.2023.
//

import SwiftUI

struct Feed: View {
    
    @State var posts = []
    @State var postsProfiles = []
    @State var postsGroups = []
    
    @Binding var imageURL: String
    @Binding var viewerShown: Bool
    
    func loadData() {
        CallAPI(function: "Newsfeed.get", params: ["extended": "1"], completion: afterNewsFeedLoad)
    }
    
    func afterNewsFeedLoad(data: [String: Any]?) {
        let response = data?["response"] as? [String: Any]
        posts = response?["items"] as? [Any] ?? []
        postsProfiles = response?["profiles"] as? [Any] ?? []
        postsGroups = response?["groups"] as? [Any] ?? []
    }
    
    var body: some View {
        Form {
            ForEach(0..<posts.count, id:\.self) {index in
                Post(
                    post: posts[index] as! Dictionary<String, Any>,
                    profiles: postsProfiles as! [Dictionary<String, Any>],
                    groups: postsGroups as! [Dictionary<String, Any>],
                    imageURL: $imageURL,
                    viewerShown: $viewerShown
                )
            }
        }.onAppear(perform: loadData)
    }
}

#Preview {
    MainView()
}
