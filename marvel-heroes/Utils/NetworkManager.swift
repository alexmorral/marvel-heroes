//
//  NetworkManager.swift
//  marvel-heroes
//
//  Created by Alex Morral on 28/12/2020.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    static func currentAPIHash(timestamp: TimeInterval) -> String {
        let stringToHash = "\(timestamp)\(marvelPrivateAPIKey)\(marvelPublicAPIKey)"
        return stringToHash.md5
    }
    
    static func getMarvelCharacters(searchTerm: String? = nil,
                                    offset: Int,
                                    success succeed: @escaping (_ response: MarvelResponse) -> (),
                                    failure fail: @escaping (_ error: Error) -> ()) {
        let currentTs = Date().timeIntervalSince1970
        var apiURLString = "https://gateway.marvel.com:443/v1/public/characters?apikey=\(marvelPublicAPIKey)&ts=\(currentTs)&hash=\(currentAPIHash(timestamp: currentTs))&offset=\(offset)"
        if let searchTerm = searchTerm {
            apiURLString.append("&nameStartsWith=\(searchTerm)")
        }
        guard let apiURL = URL(string: apiURLString) else {
            print("Incorrect URL provided")
            fail(NSError())
            return
        }
        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "get"
        
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Incorrect data provided or error not nil")
                fail(NSError())
                return
            }
            do {
                let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                succeed(marvelResponse)
                return
            } catch {
                fail(error)
                return 
            }
        }
        urlTask.resume()
    }
}
