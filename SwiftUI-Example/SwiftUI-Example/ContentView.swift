//
//  ContentView.swift
//  SwiftUI-Example
//
//  Created by Christopher Maier on 2/14/23.
//

import SwiftUI
import GiphyUISDK

struct ContentView: View {

    @State private var showingDialog = false
    @State private var showGridView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Open Grid View") {
                    showGridView.toggle()
                }

                Button("Show Giphy Dialog") {
                    showingDialog.toggle()
                }
            }
            .navigationDestination(isPresented: $showGridView) {
                GridView()
            }
            .sheet(isPresented: $showingDialog, content: {

                GiphyView()
                    .onSearch { term in
                        print("onSearch called")
                    }
                    .onCreate { term in
                        print("onCreate called")
                    }
                    .onSelectMedia { media, contentType in
                        print("onSelectMedia called")
                    }
                    .onDismiss {
                        print("onDismiss called")
                    }
                    .onTapSuggestion { suggestion in
                        print("onTapSuggestion called")
                    }
                    .onError { error in
                        print("onError called")
                    }
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                    .ignoresSafeArea(edges: .bottom)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
