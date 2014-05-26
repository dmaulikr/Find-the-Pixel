//
//  MyScene.h
//  PixelGame
//

//  Copyright (c) 2014 Gilad Oved. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property BOOL contentCreated;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic) SKSpriteNode* backgroundImageNode;
@property (nonatomic) SKSpriteNode* pixel;
@property (nonatomic) SKSpriteNode* screen;

@property (nonatomic, assign) BOOL alive;

@end
