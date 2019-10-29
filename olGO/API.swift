//
//  API.swift
//  olGO
//
//  Created by Zach Eriksen on 10/26/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import Foundation
import Combine

extension URLRequest {
    mutating func dataTaskPublish(method: String = "GET", withBody body: Data? = nil) -> URLSession.DataTaskPublisher {
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "cache-control": "no-cache",
        ]
        
        httpMethod = method
        allHTTPHeaderFields = headers
        if let body = body {
            httpBody = body
        }
        
        let session = URLSession.shared
        return session.dataTaskPublisher(for: self)
    }
}

extension URL {
    func request(forRoute route: API.Route) -> URLRequest {
        URLRequest(url: appendingPathComponent("/\(route.rawValue)"),
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
    }
}

protocol AuthRequesting {
    func register(user: User) -> URLSession.DataTaskPublisher
    func login(user: User) -> URLSession.DataTaskPublisher
    func logout() -> URLSession.DataTaskPublisher
}

protocol SocialRequesting {
    func social() -> URLSession.DataTaskPublisher
    func update(social: SocialInformation) -> URLSession.DataTaskPublisher
}

protocol PostRequesting {
    func allPosts() -> URLSession.DataTaskPublisher
    func post(withID id: Int) -> URLSession.DataTaskPublisher
    func add(post: PostItem) -> URLSession.DataTaskPublisher
    func update(post: PostItem) -> URLSession.DataTaskPublisher
    func delete(post: PostItem) -> URLSession.DataTaskPublisher
}

protocol ImageRequesting {
    func add(image: Data) -> URLSession.DataTaskPublisher
    func image(named name: String) -> URLSession.DataTaskPublisher
}

class API {
    enum Route: String {
        case register
        case login
        case logout
        case profile
    }
    
    static var instance: API = {
        API()
    }()
    // Configuations
    let path: String = "http://localhost:8080"
    
    // Lazy Variables
    lazy var url: URL = URL(string: path)!
}

extension API: AuthRequesting {
    func register(user: User) -> URLSession.DataTaskPublisher {
        let postData = try? JSONEncoder().encode(User(username: user.username,
                                                      password: user.password))
        
        var request = url.request(forRoute: .register)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: postData)
    }
    
    func login(user: User) -> URLSession.DataTaskPublisher {
        let postData = try? JSONEncoder().encode(User(username: user.username,
                                                      password: user.password))
        
        var request = url.request(forRoute: .login)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: postData)
    }
    
    func logout() -> URLSession.DataTaskPublisher {
        var request = url.request(forRoute: .logout)
        
        return request.dataTaskPublish()
    }
}
