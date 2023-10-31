//
//  API.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import Foundation

func convertToQueryString(_ parameters: [String: String]) -> String {
    return parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
}

func CallAPI(function: String, params: [String: String]=[:], completion: @escaping ([String: Any]?) -> Void) {
    
    let instance = getValueFromUserDefaults(forKey: "instance") ?? "https://openvk.su"
    let token = getValueFromKeychain(forKey: "token") ?? ""
    
    // Создаем URL для GET-запроса
    if let url = URL(string: "\(instance)/method/\(function)?access_token=\(token)&\(convertToQueryString(params))") {
        // Создаем URLSession
        let session = URLSession.shared
        
        // Создаем dataTask для выполнения GET-запроса
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(["error_msg": error.localizedDescription])
                return
            } else if let data = data {
                // Обрабатываем полученные данные
                let responseString = String(data: data, encoding: .utf8)
                do {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 500 {
                        completion(["error_msg": "Внутренняя ошибка сервера"])
                        return
                    }
                    try completion(JSONtoDict(from: responseString!))
                }
                catch let error {
                    if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                        completion(["error_msg": "Не удалось прочитать JSON."])
                    }
                    else {
                        completion(["error_msg": error.localizedDescription])
                    }
                }
                return
            }
        }
        
        // Запускаем задачу
        task.resume()
    }
    
}
