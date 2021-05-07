//
//  ViewController.m
//  ExampleObjectiveC
//
//  Created by Chris Maier on 2/20/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

#import "ViewController.h"
@import GiphyUISDK; 

@interface ViewController () <GiphyDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Giphy configureWithApiKey:@"your_api_key" verificationMode:false] ;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    GiphyViewController *giphy = [[GiphyViewController alloc]init ] ;
    giphy.theme = [[GPHTheme alloc] init];
    giphy.theme.type = GPHThemeTypeDark;
    giphy.rating = GPHRatingTypeRatedPG13;
    giphy.delegate = self;
    giphy.showConfirmationScreen = true ;
    [giphy setMediaConfigWithTypes: [ [NSMutableArray alloc] initWithObjects:
                                     @(GPHContentTypeGifs),@(GPHContentTypeStickers), @(GPHContentTypeText),@(GPHContentTypeEmoji), nil] ];
    [[GPHCache shared] clear] ; 
    [self presentViewController:giphy animated:true completion:nil] ;
}

- (void) didSelectMediaWithGiphyViewController:(GiphyViewController *)giphyViewController media:(GPHMedia *)media {
     
    /* grab url:
    NSString *url = media.images.fixedWidth.gifUrl ;
    NSString *url = media.images.fixedWidth.webPUrl ;
    */
    
}
- (void) didDismissWithController:(GiphyViewController *)controller {
    
} 
@end
