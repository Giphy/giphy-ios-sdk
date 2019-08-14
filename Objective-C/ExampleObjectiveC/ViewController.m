//
//  ViewController.m
//  ExampleObjectiveC
//
//  Created by Chris Maier on 2/20/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

#import "ViewController.h"
@import GiphyUISDK;
@import GiphyCoreSDK;

@interface ViewController () <GiphyDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiphyUISDK configureWithApiKey:@"your_api_key"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    GiphyViewController *giphy = [[GiphyViewController alloc]init ] ;
    giphy.layout = GPHGridLayoutWaterfall;
    giphy.theme = GPHThemeLight;
    giphy.rating = GPHRatingTypeRatedPG13;
    giphy.delegate = self;
    giphy.showConfirmationScreen = true ;
    [giphy setMediaConfigWithTypes: [ [NSMutableArray alloc] initWithObjects:
                                     @(GPHContentTypeGifs),@(GPHContentTypeStickers), @(GPHContentTypeText),@(GPHContentTypeEmoji), nil] ]; 
    [self presentViewController:giphy animated:true completion:nil] ;
}

- (void) didSelectMediaWithGiphyViewController:(GiphyViewController *)giphyViewController media:(GPHMedia *)media {
    
}
- (void) didDismissWithController:(GiphyViewController *)controller {
    
} 
@end
