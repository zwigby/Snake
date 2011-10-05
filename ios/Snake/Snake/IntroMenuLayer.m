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
#import "AboutLayer.h"
#import "GameManager.h"
#import "GCManager.h"
#import "FlurryAnalytics.h"

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
    [self setupMainMenu];
    [self setupSecondaryMenu];
    
    CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
    logo.position = ccp(160, 370);
    [self addChild:logo];
    
    CCMenuItemImage *pfpInfo = [CCMenuItemImage itemFromNormalImage:@"pfp_info.png" 
                                                      selectedImage:@"pfp_info.png" 
                                                             target:self 
                                                           selector:@selector(gotoPFPSite:)];
    CCMenu *pfpMenu = [CCMenu menuWithItems:pfpInfo, nil];
    [pfpInfo setAnchorPoint:ccp(0,0)];
    pfpMenu.position = ccp(10, 5);
    [self addChild:pfpMenu];
	}
	return self;
}

- (void)setupMainMenu
{
  
  CCMenuItemImage *slowButton = [CCMenuItemImage itemFromNormalImage:@"slowButton.png"
                                                       selectedImage:@"slowButtonSelected.png"
                                                              target:self
                                                            selector:@selector(playSlowGame:)];
  CCMenuItemImage *mediumButton = [CCMenuItemImage itemFromNormalImage:@"mediumButton.png"
                                                         selectedImage:@"mediumButtonSelected.png"
                                                                target:self
                                                              selector:@selector(playMediumGame:)];
  CCMenuItemImage *fastButton = [CCMenuItemImage itemFromNormalImage:@"fastButton.png"
                                                       selectedImage:@"fastButtonSelected.png"
                                                              target:self
                                                            selector:@selector(playFastGame:)];
  CCMenuItemImage *crescendoButton = [CCMenuItemImage itemFromNormalImage:@"crescendoButton.png"
                                                            selectedImage:@"crescendoButtonSelected.png"
                                                                   target:self
                                                                 selector:@selector(playProgressiveGame:)];
  CCMenu * mainMenu = [CCMenu menuWithItems:slowButton, mediumButton, fastButton, crescendoButton, nil];
  mainMenu.position = ccp(160, 180);
  [mainMenu alignItemsVerticallyWithPadding:10.0];
  [self addChild:mainMenu];
}

- (void)setupSecondaryMenu
{
  CCMenu *secondaryMenu;
  
  CCMenuItemImage *aboutButton = [CCMenuItemImage itemFromNormalImage:@"aboutButton.png"
                                                        selectedImage:@"aboutButtonSelected.png"
                                                               target:self
                                                             selector:@selector(showAboutScreen:)];
  [aboutButton setAnchorPoint:ccp(1.0, 1.0)];
  
  if([GCManager getInstance].gameCenterAvailable) {
    CCMenuItemImage *scoresButton = [CCMenuItemImage itemFromNormalImage:@"scoresButton.png"
                                                           selectedImage:@"scoresButtonSelected.png"
                                                                  target:self
                                                                selector:@selector(showGameCenter:)];
    [scoresButton setAnchorPoint:ccp(1.0, 1.0)];
    secondaryMenu = [CCMenu menuWithItems:scoresButton, aboutButton, nil];
    secondaryMenu.position = ccp(270, 470);
  } else {
    secondaryMenu = [CCMenu menuWithItems:aboutButton, nil];
    secondaryMenu.position = ccp(310, 470);
  }
  
  [secondaryMenu alignItemsHorizontallyWithPadding:10.0];
  [self addChild:secondaryMenu];
}

- (void)onEnter
{
  [super onEnter];
  [FlurryAnalytics logPageView];
}

- (void)playSlowGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].gameMode = SKGameModeNormal;
  [GameManager getInstance].tickLength = kSlowGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
  [FlurryAnalytics logEvent:@"Slow Game" timed:YES];
}

- (void)playMediumGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].gameMode = SKGameModeNormal;
  [GameManager getInstance].tickLength = kMediumGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
  [FlurryAnalytics logEvent:@"Medium Game" timed:YES];
}

- (void)playFastGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].gameMode = SKGameModeNormal;
  [GameManager getInstance].tickLength = kFastGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
  [FlurryAnalytics logEvent:@"Fast Game" timed:YES];
}

- (void)playProgressiveGame:(CCMenuItem *)menuItem 
{
  [GameManager getInstance].gameMode = SKGameModeProgressive;
  [GameManager getInstance].tickLength = kSlowGameSpeed;
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
  [FlurryAnalytics logEvent:@"Crescendo Game" timed:YES];
}

- (void)showGameCenter:(CCMenuItem *)menuItem 
{
  [[GCManager getInstance] showLeaderboard:kSlowLeaderboardId];
}

- (void)showAboutScreen:(CCMenuItem *)menuItem 
{
  [FlurryAnalytics logEvent:@"About Screen Viewed" timed:NO];
  [[CCDirector sharedDirector] replaceScene: [AboutLayer scene]];
}

- (void)gotoPFPSite:(CCMenuItemImage *)menuItem
{
  // Opens paranoid ferret website
  UIApplication *app = [UIApplication sharedApplication];
  NSURL *url = [NSURL URLWithString:@"http://paranoidferret.com"];
  [app openURL:url];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
