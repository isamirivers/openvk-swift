//
//  LogIn.swift
//  ovk
//
//  Created by Isami Riša on 24.10.2023.
//

import Foundation

func LogIn(login: String, password: String, instance: String, code: String="", completion: @escaping ([String: Any]?) -> Void) {
    
    let escaped_login = login.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let escaped_password = password.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    var query_code = ""
    
    if code != "" {
        query_code = "&code=\(code)"
    }
    
    // Создаем URL для GET-запроса
    if let url = URL(string: "\(instance)/token?username=\(escaped_login)&password=\(escaped_password)&grant_type=password&client_name=openvk_ios\(query_code)") {
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
                    try completion(JSONtoDict(from: responseString!))
                }
                catch let error {
                    if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                        completion(["error_msg": "Не удалось прочитать JSON. Вы уверены что ввели верный адрес инстанса OpenVK?"])
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
