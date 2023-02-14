//
//  ContentView.swift
//  SwiftUI-Example
//
//  Created by Christopher Maier on 2/14/23.
//

import SwiftUI
import GiphyUISDK

struct GiphyPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<GiphyPicker>) -> GiphyViewController {
         
        Giphy.configure(apiKey:"")
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 1.0
        giphy.swiftUIEnabled = true
        giphy.shouldLocalizeSearch = true
        giphy.dimBackground = true
        giphy.modalPresentationStyle = .currentContext 
        return giphy
    }
    
    func updateUIViewController(_ uiViewController: GiphyViewController, context: UIViewControllerRepresentableContext<GiphyPicker>) {
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

struct ContentView: View {
    @State private var showingDialog = false
    
    var body: some View {
        Button("Show Giphy Dialog") {
            showingDialog.toggle()
        }
        .padding()
        .sheet(isPresented: $showingDialog, content: {
            GiphyPicker()
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
