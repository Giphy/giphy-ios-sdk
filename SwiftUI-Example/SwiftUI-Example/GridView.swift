import SwiftUI
import GiphyUISDK

struct GridView: View {

    @State var content: GPHContent = .trendingGifs

    var body: some View {
        VStack {
            Button("Change content") {
                content = [
                    .search(withQuery: "the office", mediaType: .gif, language: .english),
                    .search(withQuery: "brazil", mediaType: .gif, language: .english),
                    .search(withQuery: "food", mediaType: .gif, language: .english),
                    .search(withQuery: "travel", mediaType: .gif, language: .english),
                    .search(withQuery: "america", mediaType: .gif, language: .english)
                ].randomElement()!
            }

            giphyView()
        }
    }

    @ViewBuilder func giphyView() -> some View {
        let config = GiphyGridConfiguration(theme: .dark, numberOfTracks: 3)

        GiphyGridView(
            content: $content,
            gridConfiguration: config
        )
        .onContentUpdate { count, error in
            print("onContentUpdate called")
        }
        .onSelectMedia { media in
            print("onSelectMedia called")
        }
        .onSelectMoreByYou { query in
            print("onSelectMoreByYou called")
        }
        .onScroll { offset in
            print("onScroll called")
        }
        .onError { error in
            print("onError called")
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
