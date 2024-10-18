//
//  SwiftUI_ExampleApp.swift
//  SwiftUI-Example
//
//  Created by Christopher Maier on 2/14/23.
//

import SwiftUI
import GiphyUISDK

@main
struct Example_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Giphy.configure(apiKey: "your_api_key")
                }
        }
    }
}
