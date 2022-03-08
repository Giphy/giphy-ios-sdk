## GIPHY Clips: GIFs with Sound

Introducing GIPHY Clips, aka GIFs with Sound. 

Millions of people use GIPHY to communicate and express themselves every day.  GIPHY Clips is our newest content format at the intersection of GIFs and Video. 

The Clips Library is built with all of the unforgettable quotes, cultural moments, reactions and characters that we need to express how we are feeling, what we think and who we are. Everyday you’ll find new Clips from the biggest names in Entertainment, Sports, News, Pop Culture and viral moments. If your favorite quote isn’t a Clip yet, it will be soon...

Integrating the GIPHY Clips SDK will allow your users to seamlessly express themselves with this new format, all while staying in the experience in your app. 

 
### Requirements

- GIPHY SDK v2.1.9 (or above)  
- GIPHY Clips is available for integration into our community of messaging and social apps for users to search and share.  Clips is not approved to be integrated into creation experience where derivative works can be created. 


### Showing Clips in the GiphyViewController

Add the new  `.clips`  `GPHContentType` to your `mediaTypeConfig` array. 
```
giphyViewController.mediaTypeConfig = [.gifs, .stickers, .clips]
```

Adding `.clips` to your `mediaTypeConfig` may produce a print statement in the console noting that Clips is a brand new feature which may not be ready for production releases. Disable the log by setting the `disableClipsWarning` of your `GiphyViewController`. 
 
### New GPHMediaType: .video

The new  `video` type signifies that a `GPHMedia` instance is a GIPHY Clip, and is intended to be played back as a video with sound. 
 
```

if media.type == .video { 
}


switch media.type {
    case .video: break 
    default: break  
} 
```
 
 ### GPHVideoPlayer + GPHVideoPlayerView  

Similar to the [`GPHMediaView`](https://github.com/Giphy/giphy-ios-sdk/blob/main/Docs.md#gphmediaview) which works for GIFs, Stickers, and Text, the `GPHVideoPlayerView` is a component that makes it easy to play back `GPHMedia` clips video assets. The `GPHVideoPlayerView` will only work for `GPHMedia` which has `type` property `.video`. 

Create and load a `GPHVideoPlayer + GPHVideoPlayerView` with a `GPHMedia`
```
let playerView = GPHVideoPlayerView()
let videoPlayer = GPHVideoPlayer()
videoPlayer.loadMedia(media: media, autoPlay: true, muteOnPlay: true, view: videoPlayerView, repeatable: true)
```

To use `GPHVideoPlayerView` in grids: 
```
videoPlayer.prepareMedia(media: media, view: videoView)
```
Use it to reduce CPU consumption. It prepares a view with a clip preview instead of automatically loading and playing it.

Use `videoPlayer.loadMedia` only to start playback:
```
if playClipOnLoad {
    videoPlayer.loadMedia(media: media, muteOnPlay: true, view: videoView)
} else {
    videoPlayer.prepareMedia(media: media, view: videoView)
}
``` 

Play, Stop, Pause, Mute, Unmute: 

```
videoPlayer.play()  
videoPlayer.stop()  
videoPlayer.pause()  
videoPlayer.mute(true) 
videoPlayer.mute(false)
``` 

To subscribe to `GPHVideoPlayer` events:
```
videoPlayer.addListener(GPHVideoPlayerStateListener)
```

It's preferable to use only one `GPHVideoPlayer` instance and share it between `GPHVideoPlayerView`(s)


### Sending Clips & Renditions 

As with sending / storing GIFs and Stickers, it's best practice to use GIPHY IDs to represent GIPHY Clips, rather than asset urls, and use the `gifByID` or `gifsByID` endpoints to retrieve the associated `GPHMedia`(s). More Info [here](https://github.com/Giphy/giphy-ios-sdk/blob/main/Docs.md#media-ids).

Video urls (`.mp4`) may be accessed directly within the `video` property (with type `GPHVideo`) of the encompassing `GPHMedia`.


### Rendition Limitations 

Certain renditions (cases of the `GPHRenditionType` enum) are not available for Clips. These include: 

- `preview` 
- `previewGif` 
- `looping` 
- `fixedWidthSmall` 
- `fixedWidthSmallStill`
- `fixedHeightSmall` 
- `fixedHeighSmallStill` 
- `downsizedSmall`
- `downsizedStill`
- `downsized` 

As a result, if you set the `renditionType` property of `GiphyViewController` or `GiphyGridController` to any of these, clips previews may not play back correctly in the grid. 

To account for this limitation, we created a new property specifically for clips call `clipsPreviewRenditionType` which is available as a property of both `GiphyViewController` and `GiphyGridController`. Setting this property to one of the above `GPHRenditionType` options will throw an exception. 

As with `renditionType` the default for `clipsPreviewRenditionType` is the `GPHRenditionType` option  `.fixedWidth`. 

### Showing Clips in the GiphyGridController 

Display silent Clips previews in the `GiphyGridController` collection view in the same way you would with GIFs and stickers. 

```
let trending = GPHContent.trending(mediaType: .video)  
let search = GPHContent.search(withQuery: "hello", mediaType: .video, language: .english)
``` 

We strongly reccomend providing your users with the option to play back the clip, including audio, before enabling them to send or share the clip asset, as is the case with the existing experience offered by the `GiphyViewController`. This can be accomplished by presenting a `GPHVideoView` following user selection of a clip preview. 


   
