//
//  Feed.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 01.12.2023.
//

import SwiftUI

struct Feed: View {
    
    func loadData() {
        CallAPI(function: "Newsfeed.get", completion: afterNewsFeedLoad)
    }
    
    func afterNewsFeedLoad(data: [String: Any]?) {

    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Feed()
}
