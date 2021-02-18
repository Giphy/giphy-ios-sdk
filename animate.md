## GIPHY Animated Text Creation 

### Requirements

- GIPHY SDK v2.0.5 (or above)  

### Enabling Dynamic Text in the GiphyViewController

Ensure that the  `.text` `GPHContentType` is included in your `mediaTypeConfig` array. 
```
giphyViewController.mediaTypeConfig = [.gifs, .stickers, .text]
```

Enable the GIPHY Text creation experience in the `GiphyViewController` by setting the `enableDynamicText` flag to true:
```
giphyViewController.enableDynamicText = true 
```
We recommend controlling this setting via a server side, remote config. This lets you toggle the feature with ease. 

### New GPHMedia property: isDynamic

The `isDynamic` property of `GPHMedia` signifies animated text assets that are _dynamically generated_ based on user input and are not indexed in the GIPHY Library. 

As a result, the `id` property of  dynamic media does not represent a normal GIPHY  `id`. Properties and operations such as `gifByID` will not work properly for them. 

For media that `isDynamic`, it is necessary to send or store the asset url, rather than just the media `id`. It is not possible to fetch the image assets from the `id`.  
```
if media.isDynamic {  // handle accordingly }
``` 

### GPHContent.animate (for use with `GiphyGridController`)

This feature is exposed as an additional `GPHContent` (`.animate`) constructor analogous to the existing  [`.search` and `.trending` constructors](https://github.com/Giphy/giphy-ios-sdk-ui-example/blob/master/Docs.md#giphygridcontroller-gphcontent)
```
let trending = GPHContent.trending(mediaType: .sticker)  
let search = GPHContent.search(withQuery: "hello", mediaType: .gif, language: .english)

// new: 
let animatedText = GPHContent.animate("hey what up! hope this all makes sense.") 
``` 

When populating the `GiphyGridController` with dynamic text, provide a visual indicator to clarify to the user that they are in a creation context as opposed to a search context.

### Renditions

We will only return GIF & WebP files for dynamic text. These are renditions available at launch: `original`, `fixed_width`, `fixed_width_downsampled`, `fixed_width_small`, `preview_gif`, `preview_webp`. For performance reasons, we load .gifs in the grid for dynamic text rather than .webp.
  
