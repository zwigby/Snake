//
//  IntroMenuLayer.m
//  Snake
//
//  Created by Charles Key on 8/25/11.
//  Copyright Paranoid Ferret Productions 2011. All rights reserved.
//


// Import the interfaces
#import "IntroMenuLayer.h"

#import "GameLayer.h"
#import "GameManager.h"

// IntroMenuLayer implementation
@implementation IntroMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroMenuLayer *layer = [IntroMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if((self = [super initWithColor:ccc4(204, 224, 207, 255)])) {
    [self setupMenu];
    
    CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
    logo.position = ccp(160, 370);
    [self addChild:logo];
    
    CCSprite *pfpInfo = [CCSprite spriteWithFile:@"pfp_info.png"];
    [pfpInfo setAnchorPoint:ccp(0,0)];
    pfpInfo.position = ccp(10, 5);
    [self addChild:pfpInfo];
	}
	return self;
}

- (void)setupMenu
{
  
  
  CCMenuItemImage *slowButton = [CCMenuItemImage itemFromNormalImage:@"slowButton.png"
                                                       selectedImage:@"slowButton.png"
                                                              target:self
                                                            selector:@selector(playSlowGame:)];
  CCMenuItemImage *mediumButton = [CCMenuItemImage itemFromNormalImage:@"mediumButton.png"
                                                         selectedImage:@"mediumButton.png"
                                                                target:self
                                                              selector:@selector(playMediumGame:)];
  CCMenuItemImage *fastButton = [CCMenuItemImage itemFromNormalImage:@"fastButton.png"
                                                       selectedImage:@"fastButton.png"
                                                              target:self
                                                            selector:@selector(playFastGame:)];
  CCMenu * mainMenu = [CCMenu menuWithItems:slowButton, mediumButton, fastButton, nil];
  mainMenu.position = ccp(160, 150);
  [mainMenu alignItemsVerticallyWithPadding:10.0];
  [self addChild:mainMenu];
}

- (void)playSlowGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].tickLength = kSlowGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

- (void)playMediumGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].tickLength = kMediumGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

- (void)playFastGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].tickLength = kFastGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
