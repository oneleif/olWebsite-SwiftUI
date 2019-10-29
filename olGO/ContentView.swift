//
//  ContentView.swift
//  olGO
//
//  Created by Zach Eriksen on 10/26/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    private let testUser = User(username: "Jane", password: "Doe")
    @State private var cancel: AnyCancellable?
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                let publisher = API.instance.register(user: self.testUser)
                self.cancel = publisher.sink(receiveCompletion: { (error) in
                    switch error {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                }) { (data, response) in
                    
                    if let response = response as? HTTPURLResponse {
                        print("\(response.statusCode)")
                    }
                }
                
            }) {
                Text("Register").font(.largeTitle)
            }
            Button(action: {
                let publisher = API.instance.login(user: self.testUser)
                self.cancel = publisher.sink(receiveCompletion: { (error) in
                    switch error {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        print("BEARER TOKEN")
                    }
                }) { (data, response) in
                   if let response = response as? HTTPURLResponse {
                        print("\(response.statusCode)")
                    }
                }
            }) {
                Text("Login").font(.largeTitle)
            }
            Button(action: {
                let publisher = API.instance.logout()
                self.cancel = publisher.sink(receiveCompletion: { (error) in
                    switch error {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        print("BEARER TOKEN")
                    }
                }) { (data, response) in
                   if let response = response as? HTTPURLResponse {
                        print("\(response.statusCode)")
                    }
                }
            }) {
                Text("Logout").font(.largeTitle)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
