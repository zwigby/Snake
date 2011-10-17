//
//  AboutLayer.m
//  Snake
//
//  Created by Charles Key on 10/3/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "AboutLayer.h"
#import "IntroMenuLayer.h"
#import "FlurryAnalytics.h"

@implementation AboutLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutLayer *layer = [AboutLayer node];
	
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
    
    CCSprite *bg = [CCSprite spriteWithFile:@"aboutBackground.png"];
    bg.position = ccp(160, 410);
    [bg setAnchorPoint:ccp(0.5, 1.0)];
    [self addChild:bg];
    
    CCMenuItemImage *pfpButton = [CCMenuItemImage itemFromNormalImage:@"pfpButton.png" 
                                                        selectedImage:@"pfpButtonSelected.png" 
                                                               target:self 
                                                             selector:@selector(gotoPFPSite:)];
    CCMenu *pfpMenu = [CCMenu menuWithItems:pfpButton, nil];
    pfpMenu.position = ccp(160, 330);
    [self addChild:pfpMenu];
    
    CCMenuItemImage *dnlButton = [CCMenuItemImage itemFromNormalImage:@"dnlButton.png" 
                                                        selectedImage:@"dnlButtonSelected.png" 
                                                               target:self 
                                                             selector:@selector(gotoDnlPage:)];
    CCMenu *dnlMenu = [CCMenu menuWithItems:dnlButton, nil];
    dnlMenu.position = ccp(160, 135);
    [self addChild:dnlMenu];
    
    CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"backButton.png" 
                                                         selectedImage:@"backButtonSelected.png" 
                                                                target:self 
                                                              selector:@selector(goBack:)];
    CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
    [backButton setAnchorPoint:ccp(0.0, 1.0)];
    backMenu.position = ccp(10, 470);
    [self addChild:backMenu];
	}
	return self;
}

- (void)goBack:(CCMenuItemImage *)menuItem
{
  [[CCDirector sharedDirector] replaceScene:[IntroMenuLayer scene]];
}

- (void)gotoPFPSite:(CCMenuItemImage *)menuItem
{
  // Opens paranoid ferret website
  [FlurryAnalytics logEvent:@"PFP Website Clicked" timed:NO];
  UIApplication *app = [UIApplication sharedApplication];
  NSURL *url = [NSURL URLWithString:@"http://paranoidferret.com"];
  [app openURL:url];
}

- (void)gotoDnlPage:(CCMenuItemImage *)menuItem
{
  [FlurryAnalytics logEvent:@"Drop & Lock App Clicked" timed:NO];
  UIApplication *app = [UIApplication sharedApplication];
  NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/drop-lock-lite/id442866739?ls=1&mt=8"];
  [app openURL:url];
}

@end
