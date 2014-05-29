//
//  ViewController.m
//  PixelGame
//
//  Created by Gilad Oved on 4/20/14.
//  Copyright (c) 2014 Gilad Oved. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    
    WelcomeScene* hello = [[WelcomeScene alloc] initWithSize:CGSizeMake(1024, 768)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene:hello];
    [self createAdBannerView];
    
    /*SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        // Create and configure the scene.
        
        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }*/
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    _adBannerViewIsVisible = NO;
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [self hideAd];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)hideAd {
    [UIView animateWithDuration:0.25
                     animations:^{
                         _adBannerView.frame =
                         CGRectMake(0, self.view.frame.size.height + 50, self.view.frame.size.width, 50);
                     }
                     completion:^(BOOL completed) {}];
    _adBannerView.frame =
    CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
    _adBannerViewIsVisible = NO;
}

- (void)createAdBannerView {
    self.adBannerView = [[ADBannerView alloc] initWithFrame:
                         CGRectMake(0, self.view.frame.size.width - 65, self.view.frame.size.height, 50)];
    _adBannerView.delegate = self;
    [self.view addSubview:_adBannerView];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible) {
        _adBannerViewIsVisible = YES;
    }
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (_adBannerViewIsVisible) {
        _adBannerViewIsVisible = NO;
    }
}

@end
