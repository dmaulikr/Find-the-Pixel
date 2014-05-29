//
//  WelcomeScene.m
//  PixelGame
//
//  Created by Gilad Oved on 4/20/14.
//  Copyright (c) 2014 Gilad Oved. All rights reserved.
//

#import "WelcomeScene.h"
#import "ViewController.h"

@implementation WelcomeScene

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    //self.backgroundColor = [SKColor blueColor];
    
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"introBack"];
    sn.size = self.frame.size;
    sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sn.name = @"introBack";
    
    [self addChild:sn];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newHelloNode]];
    [self addChild:[self newHelloNode2]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Arial Bold"];
    helloNode.text = @"Pixel Game!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    helloNode.name = @"helloNode";
    return helloNode;
}

- (SKLabelNode *)newHelloNode2
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Arial Bold"];
    helloNode.text = @"Tap anywhere to start the game!";
    helloNode.fontSize = 28;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 75);
    helloNode.name = @"helloNode2";
    return helloNode;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"helloNode2"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        [helloNode runAction: moveSequence completion:nil];
    }
    
    helloNode = [self childNodeWithName:@"helloNode"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        [helloNode runAction: moveSequence completion:^{
            SKScene *myScene  = [[MyScene alloc] initWithSize:self.frame.size];
            SKTransition *oa = [SKTransition fadeWithDuration:.01];
            [self.view presentScene:myScene transition:oa];
        }];
    }
}

@end
