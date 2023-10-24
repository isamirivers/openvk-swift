//
//  LogIn.swift
//  ovk
//
//  Created by Isami Riša on 24.10.2023.
//

import Foundation

func LogIn(login: String, password: String, completion: @escaping ([String: Any]?) -> Void) {
    
    let escaped_login = login.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    let escaped_password = password.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    
    // Создаем URL для GET-запроса
    if let url = URL(string: "https://openvk.su/token?username=\(escaped_login)&password=\(escaped_password)&grant_type=password") {
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
                completion(JSONtoDict(from: responseString!))
                return
            }
        }
        
        // Запускаем задачу
        task.resume()
    }
    
}
