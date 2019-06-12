# The Giphy SDK for iOS

### Setup 

#### Requirements 
- iOS 10 or later  
- Cocoapods v1.7.1  

#### CocoaPods

Add the GiphyUISDK to your Podfile like so: 
```swift
use_frameworks!
target "YourAppTarget" do 
pod 'Giphy', :podspec => 'https://s3.amazonaws.com/sdk.mobile.giphy.com/SDK/1.0/Giphy.podspec' 
end
```
**Note**: for pure Objective-C projects, add an empty swift file to your project and choose `Create the Bridging Header` when prompted by Xcode. This will allows to static libraries to be linked.

### Getting started

Here's a basic `ViewController` setup to make sure everything's working: 
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

Configure your API key. Apply for a production key [here](https://developers.giphy.com/dashboard/)
```swift
GiphyUISDK.configure(apiKey: "yOuR_kEy_HeRe")
```

Create a new `GiphyViewController`, which takes care of most of the magic.  
```swift
let giphy = GiphyViewController()
```

### Settings
- **Theme**: set the theme to be `.dark` or `.light`
```swift
giphy.theme = .dark
```

- **Layout**: set the layout to be `.waterfall` (vertical) or `.carousel` (horizontal) 
```swift
giphy.layout = .waterfall
```

- **Media types**: Set the content type(s) you'd like to show by setting the `mediaTypeConfig` property, which is an array of `GPHContentType`s 
<br> note: note: Emoji only is not available for the carousel layout option. 
```swift
giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]
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

- **Open in app**:  option to open or not the gifs or artists on th GIPHY app. Default `true`.
```swift
giphy.showViewOnGiphy = true
```

### Presentation 

Present the `GiphyViewController` & watch as the GIFS start flowin'.
```swift
present(giphy, animated: true, completion: nil)
```

### Events
Set the delegate and conform to the `GiphyDelegate` protocol to handle GIF selection.
```swift
giphy.delegate = self
```

```swift
extension YourController: GiphyDelegate {
   func didSelectMedia(_ media: GPHMedia) {
        // your user tapped a GIF! 
   }
   
   func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a gif.  
   }
}
```

From there, it's up to you to decide what to do with the GIF. 

Create a `GPHMediaView` to display the media: 

```swift
let imageView = GPHMediaView() 
imageView.media = media  
```
You can also populate a `GPHMediaView` with a media `id` like so: 
```swift
imageView.setMediaWithID(id)  
```

Use the media's `aspectRatio` property to size the view: 
```swift
let aspectRatio = medaiView.media?.aspectRatio 
```

Or grab a URL to the asset like so:  
```swift
let webpURL = media.url(rendition: .original, fileType: .webp) 
let gifURL = media.url(rendition: .fixedWidth, fileType: .gif) 
let vidURL = media.url(rendition: .fixedWidth, fileType: .mp4) 

let url = URL(string: gifURL) 
```
## Buttons

There are two button classes provided for you to use if you choose to.

### GPHBrandButton

A square button with a small GIPHY logo.

```swift
let button = GPHBrandButton()
button.fill = .color // logo fill color (.color, .white, or .black)
button.rounded = true // whether corners should be round
```

### GPHGenericButton

A generic button with the word "GIF" available in multiple styles.

```swift
let button = GPHGenericButton()
button.style = .color // button fill style (.color, .white, or .outline)
button.gradient = .black // button fill color (.pink, .blue, .black or .white)
button.rounded = true // whether corners should be round
```

## Caching 
We use [PINCache](https://github.com/pinterest/PINCache) to cache media assets, which reduces unnecessary image requests and loading times. We create our own instance of PINCache which you can access via `GPHCache.shared.pinCache`. 

By default, we use both PINCache’s memory cache and disk cache. The disk cache is limited to 300 mb by default, but you can set to whatever you’d like: 

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

* Answer `yes` when asked if the app uses an advertising identifier & be sure to check:
    - [x]  Serve advertisements within the app
    - [x]  Attribute an action taken within this app to a previously served advertisement
