# GIPHY SDK for iOS

### Setup 

#### Requirements 
- iOS 10 or later  
- Cocoapods v1.7.1 or later 
- A Giphy API key from the [Giphy Developer Portal](https://developers.giphy.com/dashboard/?create=true).
- Xcode 10.2 or later 

#### Github Example Repo 

The SDK is currently exclusively available through Cocoapods, but we still use Github for releases, issue / feature tracking, and more. 

Here you can: 
- View the most up-to-date documentation. The documentation on the developer portal may not always reflect the latest release. 
- Run the example app to see the GIPHY SDK in action with all of its configurations. It is necessary to run `pod install` before building the example app. 
- Open [issues or feature requests](https://github.com/Giphy/giphy-ios-sdk-ui-example/issues)  
- View [releases](https://github.com/Giphy/giphy-ios-sdk-ui-example/releases)

#### CocoaPods

Add the GiphyUISDK to your Podfile like so: 
```swift
use_frameworks!
target "YourAppTarget" do 
pod 'Giphy' 
end
```
**Note**: for pure Objective-C projects, add an empty swift file to your project and choose `Create the Bridging Header` when prompted by Xcode. This allows static libraries to be linked.

### Getting started
Here's a basic `ViewController` setup to make sure everything's working. 
Make sure to configure the GIPHY SDK with your API key.
```swift
import UIKit
import GiphyUISDK 
import GiphyCoreSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad() 
        GiphyUISDK.configure(apiKey: "your api key here")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true )
        present(GiphyViewController(), animated: true, completion: nil)
    }
}
```


## Basic Usage 

### Swift 

First things first, be sure to import: 
```swift
import GiphyUISDK
import GiphyCoreSDK
```

Configure your API key. Apply for an API key [here](https://developers.giphy.com/dashboard/).
```swift
GiphyUISDK.configure(apiKey: "yOuR_kEy_HeRe")
```

Create a new `GiphyViewController`, which takes care of most of the magic.  
```swift
let giphy = GiphyViewController()
```

Create a new `GiphyViewController` every time you want to show GIPHY (maintaining a reference to the same `GiphyViewController` object isn't necesssary and can impact performance, and lead to unexpected results) 

#### Settings
- **Theme**: set the theme to be `.dark` or `.light`.
```swift
giphy.theme = .dark
```

- **Layout**: set the layout to be `.waterfall` (vertical) or `.carousel` (horizontal).
```swift
giphy.layout = .waterfall
```

- **Media types**: Set the content type(s) you'd like to show by setting the `mediaTypeConfig` property, which is an array of `GPHContentType`s.
<br> **Note**: Emoji only is not available for the carousel layout option. 
```swift
giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]
```
_Objective-C_: 
```Objective-C
[giphy setMediaConfigWithTypes: [[ NSMutableArray alloc] initWithObjects: 
@(GPHContentTypeGifs), @(GPHContentTypeStickers), @(GPHContentTypeText), @(GPHContentTypeEmoji), nil ] ]; 
```

- **Confirmation screen**:  we provide the option to show a secondary confirmation screen when the user taps a GIF, which shows a larger rendition of the asset.
This confirmation screen is only available for `.waterfall` mode - this property will be ignored if the `layout` is `.carousel`. 
```swift
giphy.showConfirmationScreen = true 
```

- **Rating**: set a specific content rating for the search results. Default `ratedPG13`.
```swift
giphy.rating = .ratedPG13
```

- **Rendition**:  option to select the rendition type for the grid.  Default `fixedWidth`.
```swift
giphy.renditionType = .fixedWidth 
```

- **Localization**:  option to choose whether or not to localize the search results based on phone settings. Default `false` will set the language to `en`.
```swift
giphy.shouldLocalizeSearch = false
```

- **Open in app**:  option to open or not the GIFs or artists on the GIPHY app. Default `true`.
```swift
giphy.showViewOnGiphy = true
```

- **Tray Height**: height for the tray's "snap point" as a ratio of the `GiphyViewController`'s height. Default `0.7`
```swift
GiphyViewController.trayHeightMultiplier = 0.7 
```

#### Presentation 

Present the `GiphyViewController` and watch as the GIFs start flowin'.
```swift
present(giphy, animated: true, completion: nil)
```

#### Events
Set the delegate and conform to the `GiphyDelegate` protocol to handle GIF selection.
```swift
giphy.delegate = self
```

```swift
extension YourController: GiphyDelegate { 
   func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia)   {
   
        // your user tapped a GIF!   
        giphyViewController.dismiss(animated: true, completion: nil) 
   }
   
   func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a GIF.  
   }
}
```

From there, it's up to you to decide what to do with the GIF. 

#### GPHMediaView

Create a `GPHMediaView` to display the media: 

```swift
let mediaView = GPHMediaView() 
mediaView.media = media  
```

Use the media's `aspectRatio` property to size the view: 
```swift
let aspectRatio = media.aspectRatio 
```

If you want to build your own view to display a GIF, grab a URL to the asset like so:  
```swift
let webpURL = media.url(rendition: .original, fileType: .webp) 
let gifURL = media.url(rendition: .fixedWidth, fileType: .gif) 
let vidURL = media.url(rendition: .fixedWidth, fileType: .mp4) 

let url = URL(string: gifURL) 
```


#### Media IDs

In a messaging app context, you may want to send media `id`s rather than `GPHMedia` objects or image assets. 

Obtain a `GPHMedia`'s `id` property via `media.id` 

On the receiving end, obtain a `GPHMedia` from the `id` like so: 
 
```swift
GiphyCore.shared.gifByID(id) { (response, error) in
    if let media = response?.data {
        DispatchQueue.main.sync { [weak self] in 
            self?.mediaView.media = media
        }
    }
}
```




## Buttons

There are three button classes provided for you to use if you choose to.

#### GPHGiphyButton

GIPHY branded button available in the following styles:

- `logo` - full giphy logo
- `logoRounded` - same styles as `logo` with rounded corners
- `iconSquare` - square giphy icon logo with black background
- `iconSquareRounded` - same styles as `iconSquare` with rounded corners
- `iconColor` - color version of giphy icon logo with transparent background
- `iconBlack` - solid black version of the giphy icon logo with transparent background
- `iconWhite` - solid white version of the giphy icon logo with transparent background

```
let button = GPHGiphyButton()
button.style = .logoSquareRounded
```


#### GPHGifButton

Generic gif button with the text "GIF", available in the following styles:

- `rectangle` - rectuangular "pill" style button with solid background and transparent text
- `rectangleRounded` - same styles as `rectangle` with rounded corners
- `rectangleOutline` - rectuangluar "pill" style button with solid text and an outline
- `rectangleOutlineRounded` - same styles as `rectangleOutline` with rounded corners
- `square` - same styles as `rectangle` but square with smaller text
- `squareRounded` - same styles as `square` with rounded corners
- `squareOutline` - same styles as `rectangleOutline` but square with smaller text
- `squareOutlineRounded` - same styles as `squareOutline` with rounded corners
- `text` - transparent background button with "gif" text only

The `GPHGifButton` is also available in the following colors:

- `pink` - pink and purple gradient
- `blue` - blue and purple gradient
- `black` - solid black
- ` white` - solid white

```
let button = GPHGifButton()
button.style = .squareRounded
button.color = .blue
```


#### GPHContentTypeButton

Icon buttons for the different supported icon types. These come in the following styles:

- `stickers` - solid sticker icon
- `stickersOutline` - outline version of the `stickers` button
- `emoji` - solid emoji smiley icon
- `emojiOutline` - outline version of the `emoji` button
- `text` - solid text speech bubble icon
- `textOutline` - outline version of the `text` button

The `GPHContentTypeButton` is also available in the following colors:

- `pink` - pink and purple gradient
- `blue` - blue and purple gradient
- `black` - solid black
- ` white` - solid white

```
let button = GPHContentTypeButton()
button.style = .emoji
button.color = .black
```


## Caching 
We use [PINCache](https://github.com/pinterest/PINCache) to cache media assets, which reduces unnecessary image requests and loading times. We create our own instance of PINCache which you can access via `GPHCache.shared.pinCache`. 

By default, we use both PINCache’s memory cache and disk cache. The disk cache is limited to 300 mb by default, but you can set it to any value you’d like: 

```swift
// set to 300 mb
GPHCache.shared.pinCache.diskCache.byteLimit = 300 * 1000 * 1000
```
If you only want to cache GIFs in memory, set 
`GPHCache.shared.setting` to `memoryOnly` like so 
```swift
GPHCache.shared.setting = .memoryOnly 
``` 
Similarly, you can cache only to disk with: 
```swift
GPHCache.shared.setting = .diskOnly 
```
Note: We *don't* automatically clear the cache when the `GiphyViewController` is dismissed. 
Manually clear the cache on your convenience by calling `GPHCache.shared.clear()` to clear the cache based on your setting, or `GPHCache.shared.clear(.memoryOnly)` to choose a specific cache you want to clear.

## Dependencies  
[PINCache](https://github.com/pinterest/PINCache): image caching <br> 
[YYImage](https://github.com/ibireme/YYImage): GIF playback <br>
[libwebp](https://github.com/webmproject/libwebp): webp playback <br>
[DeepDiff](https://github.com/onmyway133/DeepDiff): Collection view diffing algorithm <br> 

## Sponsored Content

We serve sponsored content every now and then so we can continue building great products and sharing the joy of GIFs across the Internet, and in apps like yours.  

As a result, you’ll have to check a few boxes when you submit your app for review on the App Store if you’ve integrated this SDK. 

* Answer `yes` when asked if the app uses an advertising identifier and be sure to check:
    - [x]  Serve advertisements within the app
    - [x]  Attribute an action taken within this app to a previously served advertisement
