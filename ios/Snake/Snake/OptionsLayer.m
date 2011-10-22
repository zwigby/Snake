//
//  OptionsLayer.m
//  Snake
//
//  Created by Charles Key on 10/21/11.
//  Copyright (c) 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "OptionsLayer.h"
#import "IntroMenuLayer.h"
#import "CCRadioMenu.h"
#import "GameManager.h"
#import "FlurryAnalytics.h"

@implementation OptionsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionsLayer *layer = [OptionsLayer node];
	
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
    
    CCSprite *bg = [CCSprite spriteWithFile:@"optionsBackground.png"];
    bg.position = ccp(160, 410);
    [bg setAnchorPoint:ccp(0.5, 1.0)];
    [self addChild:bg];
    
    helpText = [[CCLabelBMFont labelWithString:DIRECTIONAL_SWIPE_HELP fntFile:@"lcd_solid.fnt"] retain];
    [helpText setAnchorPoint:ccp(0, 1.0)];
    helpText.position = ccp(33, 100);
    
    [self setupMenu];
    
    [self addChild:helpText];
    
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

- (void)setupMenu
{
  GameManager *gameManager = [GameManager getInstance];
  
  CCMenuItemImage *directionSwipeButton = [CCMenuItemImage itemFromNormalImage:@"optionsDirectionSwipeButton.png"
                                                                 selectedImage:@"optionsDirectionSwipeButtonSelected.png"
                                                                        target:self
                                                                      selector:@selector(selectDirectionSwipe)];
  directionSwipeButton.position = ccp(0, 10);
  if(gameManager.controlMode == SKControlModeSwipe) {
    [directionSwipeButton selected];
    [helpText setString:DIRECTIONAL_SWIPE_HELP];
  }
  
  CCMenuItemImage *dpadButton = [CCMenuItemImage itemFromNormalImage:@"optionsDpadButton.png"
                                                       selectedImage:@"optionsDpadButtonSelected.png"
                                                              target:self
                                                            selector:@selector(selectDpad)];
  dpadButton.position = ccp(0, -55);
  if(gameManager.controlMode == SKControlModeDPad) {
    [dpadButton selected];
    [helpText setString:DPAD_HELP];
  }
  
  CCMenuItemImage *headClickButton = [CCMenuItemImage itemFromNormalImage:@"optionsHeadClickButton.png"
                                                            selectedImage:@"optionsHeadClickButtonSelected.png"
                                                                   target:self
                                                                 selector:@selector(selectHeadClick)];
  headClickButton.position = ccp(0, -120);
  if(gameManager.controlMode == SKControlModeHeadClick) {
    [headClickButton selected];
    [helpText setString:HEAD_CLICK_HELP];
  }
  
  CCRadioMenu *controlsMenu = [CCRadioMenu menuWithItems:directionSwipeButton, dpadButton, headClickButton, nil];
  
  controlsMenu.position = ccp(160, 260);
  
  [self addChild:controlsMenu];
}

- (void)selectDirectionSwipe
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Direction Swipe", @"Mode", nil];
  [FlurryAnalytics logEvent:@"Control Mode Changed" withParameters:params];
  [GameManager getInstance].controlMode = SKControlModeSwipe;
  [helpText setString:DIRECTIONAL_SWIPE_HELP];
}

- (void)selectDpad
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"D-Pad", @"Mode", nil];
  [FlurryAnalytics logEvent:@"Control Mode Changed" withParameters:params];
  [GameManager getInstance].controlMode = SKControlModeDPad;
  [helpText setString:DPAD_HELP];
}

- (void)selectHeadClick
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Head Click", @"Mode", nil];
  [FlurryAnalytics logEvent:@"Control Mode Changed" withParameters:params];
  [GameManager getInstance].controlMode = SKControlModeHeadClick;
  [helpText setString:HEAD_CLICK_HELP];
}

- (void)goBack:(CCMenuItemImage *)menuItem
{
  [[GameManager getInstance] saveOptions];
  [[CCDirector sharedDirector] replaceScene:[IntroMenuLayer scene]];
}

@end
