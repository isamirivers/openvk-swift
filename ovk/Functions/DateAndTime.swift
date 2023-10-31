//
//  DateAndTime.swift
//  ovk
//
//  Created by Isami Riša on 26.10.2023.
//

import Foundation

func convertTimestampToStatus(_ timestamp: Int, sex: Int=0) -> String {
    
    func getLastDigit(from number: Int) -> Int? {
        let numberString = String(number)
        guard let lastCharacter = numberString.last else {
            return nil
        }
        return Int(String(lastCharacter))
    }
    
    let currentTime = Int(Date().timeIntervalSince1970)
    let timeDifference = (currentTime - timestamp) / 60
    var a = ""
    if sex == 1 {a = getLocalizedString(key: "gender_female_a")}
    
    if timeDifference < 60 {
        return "\(getLocalizedString(key: "Was"))\(a) \(getLocalizedString(key: "online")) \(timeDifference) \(getLocalizedString(key: "minutes_ago"))"
    }
    else if timeDifference < 1440 {
        var hour_a = getLocalizedString(key: "time_spelling_c")
        switch (getLastDigit(from: timeDifference/60)) {
        case 1:
            hour_a = getLocalizedString(key: "time_spelling_a")
            break
        case 5,6,7,8,9,0:
            hour_a = getLocalizedString(key: "time_spelling_b") //ов
            break
        default:
            hour_a = getLocalizedString(key: "time_spelling_c") //a
            break
        }
        
        return "\(getLocalizedString(key: "Was"))\(a) \(getLocalizedString(key: "online")) \(timeDifference/60) \(getLocalizedString(key: "hour"))\(hour_a)\(getLocalizedString(key: "ago"))"
    }
    else {
        let dateFormatter_1 = DateFormatter()
        let dateFormatter_2 = DateFormatter()
        dateFormatter_1.dateFormat = "d MMM YY"
        dateFormatter_2.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formattedDate_1 = dateFormatter_1.string(from: date)
        let formattedDate_2 = dateFormatter_2.string(from: date)
        return "\(getLocalizedString(key: "Was")) \(a)\(getLocalizedString(key: "online")) \(formattedDate_1) \(getLocalizedString(key: "at")) \(formattedDate_2)"
    }
}
