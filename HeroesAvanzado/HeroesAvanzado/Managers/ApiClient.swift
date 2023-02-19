//
//  ApiClient.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 18/02/23.
//

import Foundation

enum NetworkError: Error {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case unknown
}

final class ApiClient {
    static let shared = ApiClient()
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void){
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        let loginString =  "\(email):\(password)"
        let loginData:  Data = loginString.data(using: .utf8)!
        let base64 = loginData.base64EncodedString()
        
        var urlRequest =  URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response , error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
                
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(token, nil)
        }
        task.resume()
    }
    
    func fetchHeroes(token: String?, completion: @escaping([Heroe]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
                     
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let heroes = try? JSONDecoder().decode([Heroe].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(heroes, nil)
        }
        
        task.resume()
    }
    
    
    func marcaFavorito(token: String?, id: String?, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/data/herolike") else {
            completion("nil", NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "hero", value: id ?? "")]
                     
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion("Marcado", nil)
        }
        task.resume()
    }
    
    func fetchLocations(token: String?, id: String?, completion: @escaping([Locations]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/locations") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: id ?? "")]
                     
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let locations = try? JSONDecoder().decode([Locations].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(locations, nil)
        }
        
        task.resume()
    }
}

