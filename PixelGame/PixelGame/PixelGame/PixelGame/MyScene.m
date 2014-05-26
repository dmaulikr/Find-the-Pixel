//
//  MyScene.m
//  PixelGame
//
//  Created by Gilad Oved on 4/20/14.
//  Copyright (c) 2014 Gilad Oved. All rights reserved.
//

#import "MyScene.h"
#include <stdlib.h>

@implementation MyScene {
    BOOL countdown;
    int time;
    int taps;
    CGSize viewB;
    
    SKLabelNode *myLabel;
    
    SKLabelNode* timeLabel;
    SKLabelNode* tapsLabel;
    int lastRecordedTime;
    
    BOOL won;
    BOOL gameOver;
    
    float x;
    float y;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        viewB = size;
        [self initBackground:viewB];
        [self initHud];
        
        x = 2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f;
        y = 2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f;
        
        countdown = YES;
        gameOver = NO;
        time = 0;
        taps = 0;
        won = NO;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Game Over!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        myLabel.hidden = YES;
        [self addChild:myLabel];
        self.alive = NO;
    }
    return self;
}

- (void) initBackground:(CGSize) sceneSize
{
    self.backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"background1.jpg"];
    self.backgroundImageNode.size = sceneSize;
    self.backgroundImageNode.position = CGPointMake(self.backgroundImageNode.size.width/2, self.frame.size.height/2);
    [self addChild:self.backgroundImageNode];
    
    self.pixel = [SKSpriteNode new];
    self.pixel  = [SKSpriteNode spriteNodeWithImageNamed:@"pixel.gif"];
    self.pixel.name = @"pixel";
    self.pixel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    self.screen = [SKSpriteNode new];
    self.screen.color = [UIColor clearColor];
    self.screen.name = @"screen";
    self.screen.size = CGSizeMake(20, 20);
    self.screen.position = CGPointMake(self.pixel.position.x, self.pixel.position.y);
}

-(void)initHud {
    timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    timeLabel.name = @"timeLabel";
    timeLabel.fontSize = 24;
    timeLabel.fontColor = [SKColor greenColor];
    timeLabel.text = [NSString stringWithFormat:@"Time: %d", time];
    timeLabel.position = CGPointMake(20 + timeLabel.frame.size.width/2, self.size.height - (20 + timeLabel.frame.size.height/2));
    [self addChild:timeLabel];
    
    tapsLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    tapsLabel.name = @"tapsLabel";
    tapsLabel.fontSize = 24;
    tapsLabel.fontColor = [SKColor redColor];
    tapsLabel.text = [NSString stringWithFormat:@"Taps: %d", taps];
    tapsLabel.position = CGPointMake(self.size.width - tapsLabel.frame.size.width/2 - 20, self.size.height - (20 + tapsLabel.frame.size.height/2));
    [self addChild:tapsLabel];
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        time++;
        if (countdown) {
            NSLog(@"counting! time: %d", time);
            if (time > 4) {
                countdown = NO;
                time = 1;
                self.alive = YES;
                [self addChild:self.screen];
                [self addChild:self.pixel];
            }
            else {
                SKNode *countNode = [self countdownNode];
                if (countNode != nil)
                {
                    countNode.name = nil;
                    [self addChild:countNode];
                    SKAction *fadeAway = [SKAction fadeInWithDuration:.75];
                    SKAction *remove = [SKAction removeFromParent];
                    SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
                    [countNode runAction:moveSequence completion:nil];
                }
            }
        } else {
            if (self.alive) {
                NSLog(@"game time: %d", time);
                timeLabel.text = [NSString stringWithFormat:@"Time: %d", time];
                lastRecordedTime = time;
                
                x = 2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f;
                y = 2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f;
                x *= 1.2;
                y *= 1.2;
                NSLog(@"new x! %f", x);
            }
            else {
                gameOver = YES;
                self.alive = NO;
                timeLabel.text = [NSString stringWithFormat:@"Time: %d", lastRecordedTime];
                if (!won) {
                    myLabel.text = @"Game Over Loser!";
                    myLabel.hidden = NO;
                }
            }
        }
    }
}

- (SKLabelNode *)countdownNode
{
    SKLabelNode *countNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    if (time != 4)
        countNode.text = [NSString stringWithFormat:@"%d", 4 - time];
    else
        countNode.text = @"Begin!";
    countNode.fontSize = 122;
    countNode.fontColor = [SKColor blackColor];
    countNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    //countNode.name = @"countNode";
    return countNode;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //CGPoint location = [touch locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    if (self.alive) {
        taps++;
        tapsLabel.text = [NSString stringWithFormat:@"Taps: %d", taps];
    }
    else {
        if (gameOver) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
            MyScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene transition: reveal];
        }
    }
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"screen"]) {
            if (!countdown) {
                NSLog(@"touched!!!!");
                self.alive = NO;
                myLabel.text = @"Ya Won Kiiiiid";
                myLabel.hidden = NO;
                won = YES;
            }
        }
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    if (!countdown && self.alive) {
        if (self.pixel.position.x < 0 || self.pixel.position.x > self.view.frame.size.width || self.pixel.position.y < 0 || self.pixel.position.y > self.view.frame.size.height) {
            [self.pixel removeFromParent];
            [self.screen removeFromParent];
            self.alive = NO;
        }
        
        SKAction *movePixel = [SKAction moveByX:x y:y duration:1.0/60.0];
        [self.screen runAction:movePixel];
        self.pixel.position = self.screen.position;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

@end
