//
//  Popup.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 02.11.2023.
//

import Foundation
import SwiftUI
import WebKit

struct UserInfoPopup: View { 
    
    var sex_values = [
        0: "они/их",
        1: "она/её",
        2: "он/его"
    ]
    
    @Binding var sex: Int
    
    @Binding var music: String
    @Binding var movies: String
    @Binding var tv: String
    @Binding var books: String
    @Binding var city: String
    @Binding var interests: String
    
    @Binding var quotes: String
    @Binding var email: String
    @Binding var telegram: String
    @Binding var about: String
    
    var body: some View {
        Form {
            
            Section {
                if email != "" {
                    VStack (alignment: .leading) {
                        Text("E-mail")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(email)
                    }
                }
                if telegram != "" {
                    VStack (alignment: .leading) {
                        Text("Telegram")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(telegram)
                    }
                }
                if city != "" {
                    Section {
                        VStack (alignment: .leading) {
                            Text("Город")
                                .font(.callout.smallCaps())
                                .foregroundStyle(.secondary)
                            Text(city)
                        }
                    }
                }
            }.modifier(FormElevateOnWhiteBackground())
            
            Section {
                
                if interests != "" {
                    VStack (alignment: .leading) {
                        Text("Интересы")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(interests)
                    }
                }
                
                if music != "" {
                    VStack (alignment: .leading) {
                        Text("Любимая музыка")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(music)
                    }
                }
                
                if movies != "" {
                    VStack (alignment: .leading) {
                        Text("Любимые фильмы")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(movies)
                    }
                }
                
                if tv != "" {
                    VStack (alignment: .leading) {
                        Text("Любимые ТВ-шоу")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(tv)
                    }
                }
                
                if music != "" {
                    VStack (alignment: .leading) {
                        Text("Любимые книги")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(books)
                    }
                }
                
                if quotes != "" {
                    VStack (alignment: .leading) {
                        Text("Любимые цитаты")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(quotes)
                    }
                }
                
                if about != "" {
                    VStack (alignment: .leading) {
                        Text("О себе")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(about)
                    }
                }
                
            }.modifier(FormElevateOnWhiteBackground())
            
            Section {
                VStack (alignment: .leading) {
                    Text("Местоимения")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(sex_values[sex] ?? "Неизвестно")
                }
            }.modifier(FormElevateOnWhiteBackground())
            
        }
    }
    
}
