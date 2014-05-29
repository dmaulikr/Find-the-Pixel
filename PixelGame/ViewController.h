//
//  ViewController.h
//  PixelGame
//

//  Copyright (c) 2014 Gilad Oved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "WelcomeScene.h"
#import <iAd/iAd.h>

@interface ViewController : UIViewController <ADBannerViewDelegate>
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL adBannerViewIsVisible;
- (void)hideAd;
@end
