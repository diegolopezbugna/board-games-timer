//
//  BaseConnector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 23/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation
import XMLParsing

class BaseConnector {
    let baseUrlString = "https://boardgamegeek.com/"

    var baseUrl: URL
    
    init() {
        self.baseUrl = URL(string: baseUrlString)!
    }
    
    internal func requestDecodable<T: Decodable>(uri: String, queryItems: [URLQueryItem], completion: @escaping (T?) -> Void) {
        var urlComponents = URLComponents(string: uri)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url(relativeTo: self.baseUrl) else {
            NSLog("ERROR: can't form url from \(self.baseUrl.absoluteString) \(uri)")
            completion(nil)
            return
        }
        NSLog("URL: \(url.absoluteString)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                NSLog("ERROR: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                NSLog("DATA NIL")
                completion(nil)
                return
            }
            
            NSLog("DATA: \(String(data: data, encoding: .utf8)!)")
            
            let decoder = XMLDecoder()
            do {
                let decodable = try decoder.decode(T.self, from: data)
                print("decoded: ", decodable)
                completion(decodable)
            } catch {
                NSLog("ERROR PARSING: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    internal func requestDecodable<T: Decodable>(uri: String, completion: @escaping (T?) -> Void) {
        requestDecodable(uri: uri, queryItems: [], completion: completion)
    }
    
    internal func getData(uri: String, queryItems: [URLQueryItem], completion: @escaping (Data?) -> Void) {
        var urlComponents = URLComponents(string: uri)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url(relativeTo: self.baseUrl) else {
            NSLog("ERROR: can't form url from \(self.baseUrl.absoluteString) \(uri)")
            completion(nil)
            return
        }
        NSLog("URL: \(url.absoluteString)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                NSLog("ERROR: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                NSLog("DATA NIL")
                completion(nil)
                return
            }
            
            completion(data)
        }
        task.resume()
    }
}
