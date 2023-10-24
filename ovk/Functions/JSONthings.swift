//
//  JSONtoDict.swift
//  ovk
//
//  Created by Isami Riša on 24.10.2023.
//

import Foundation

func JSONtoDict(from jsonString: String) -> [String: Any]? {
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDict = jsonObject as? [String: Any] {
                return jsonDict
            }
        } catch {
            print("Error: \(error)")
        }
    }
    return nil
}

func DictToString(from dictionary: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        print("Error: \(error)")
    }
    return nil
}
