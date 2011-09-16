//
//  GameOverLayer.m
//  Snake
//
//  Created by Charles Key on 8/28/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "GameOverLayer.h"

#import "IntroMenuLayer.h"
#import "GameLayer.h"
#import "GameManager.h"
#import "GCManager.h"
#import "FlurryAnalytics.h"

@implementation GameOverLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
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
    
    CCSprite *gameOver = [CCSprite spriteWithFile:@"game_over.png"];
    gameOver.position = ccp(160, 370);
    [self addChild:gameOver];
    
    NSString *score = [NSString stringWithFormat:@"Score: %d", [GameManager getInstance].currentScore];
    
    CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:score fntFile:@"lcd_solid.fnt"];
    [scoreLabel setAnchorPoint:ccp(0, 1.0)];
    scoreLabel.position = ccp(10, 475);
    
    [self addChild:scoreLabel];
    
    [self setupMenu];
	}
	return self;
}

- (void)setupMenu
{
  CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:@"playAgainButton.png"
                                                       selectedImage:@"playAgainButtonSelected.png"
                                                              target:self
                                                            selector:@selector(playGame:)];
  CCMenuItemImage *quitButton = [CCMenuItemImage itemFromNormalImage:@"quitLargeButton.png"
                                                      selectedImage:@"quitLargeButtonSelected.png"
                                                             target:self
                                                           selector:@selector(quitGame:)];
  CCMenu *mainMenu;
  if([GCManager getInstance].gameCenterAvailable) {
    CCMenuItemImage *highscoresButton = [CCMenuItemImage itemFromNormalImage:@"highscoresButton.png"
                                                               selectedImage:@"highscoresButtonSelected.png"
                                                                      target:self
                                                                    selector:@selector(showHighscores:)];
    mainMenu = [CCMenu menuWithItems:playButton, quitButton, highscoresButton, nil];
  } else {
    mainMenu = [CCMenu menuWithItems:playButton, quitButton, nil];
  }
  mainMenu.position = ccp(160, 150);
  [mainMenu alignItemsVerticallyWithPadding:10.0];
  [self addChild:mainMenu];
}

- (void)onEnter
{
  [super onEnter];
  [FlurryAnalytics logPageView];
}

- (void)playGame:(CCMenuItem *)menuItem 
{
  [[GameManager getInstance] handleGameReplay];
  [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

- (void)quitGame:(CCMenuItem *)menuItem 
{
  [[CCDirector sharedDirector] replaceScene: [IntroMenuLayer scene]];
}

- (void)showHighscores:(CCMenuItem *)menuItem
{
  [[GameManager getInstance] showLeaderboard];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
