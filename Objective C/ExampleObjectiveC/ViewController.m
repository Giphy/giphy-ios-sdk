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
    [GiphyUISDK configureWithApiKey:@"n94ojrymc9HLW"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    GiphyViewController *giphy = [[GiphyViewController alloc]init ] ;
    giphy.layout = GPHGridLayoutWaterfall;
    giphy.theme = GPHThemeLight;
    giphy.rating = GPHRatingTypeRatedPG13;
    giphy.delegate = self;
    giphy.showConfirmationScreen = true ; 
    [self presentViewController:giphy animated:true completion:nil] ;
}

- (void)didSelectMedia:(GPHMedia * _Nonnull) media {
    NSLog(@"selected media");
}


@end
