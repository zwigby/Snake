//
//  GameLayer.m
//  Snake
//
//  Created by Charles Key on 8/25/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "GameLayer.h"

#import "CCTouchDispatcher.h"
#import "IntroMenuLayer.h"
#import "GameOverLayer.h"
#import "Snake.h"
#import "SnakePiece.h"
#import "Apple.h"
#import "GameManager.h"
#import "FlurryAnalytics.h"

@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if((self = [super initWithColor:ccc4(204, 224, 207, 255)])) {
    
    gameManager = [GameManager getInstance];
    gameManager.currentScore = 0;
    
    if(gameManager.controlMode == SKControlModeDPad) {
      bg = [[CCSprite alloc] initWithFile:@"game_screen_small.png"];
      bg.anchorPoint = ccp(0.5, 1.0);
      bg.position = ccp(160, 457);
      [self setupDPad];
    } else {
      bg = [[CCSprite alloc] initWithFile:@"game_screen.png"];
      bg.anchorPoint = ccp(0.5, 1.0);
      bg.position = ccp(160, 457);
      self.isTouchEnabled = true;
    }
    
    [self addChild:bg];
    
    scoreLabel = [[CCLabelBMFont labelWithString:@"Score: 0" fntFile:@"lcd_solid.fnt"] retain];
    [scoreLabel setAnchorPoint:ccp(0, 1.0)];
    scoreLabel.position = ccp(10, 475);
    
    [self addChild:scoreLabel];
    
    int64_t hscore = [gameManager getHighScore];
    if(hscore != -1) {
      NSString *hscoreString = [NSString stringWithFormat:@"High Score: %d", hscore];
      highscoreLabel = [[CCLabelBMFont labelWithString:hscoreString fntFile:@"lcd_solid.fnt"] retain];
      [highscoreLabel setAnchorPoint:ccp(1.0, 1.0)];
      highscoreLabel.position = ccp(310, 475);
      
      if(hscore == 0) {
        highscoreLabel.visible = NO;
      }
      
      [self addChild:highscoreLabel];
    }
    
    [self setupMenu];
    
    apple = [[Apple alloc] initWithPosition:[self getRandomApplePosition]];
    
    [self addChild:apple];
    
    snake = [[Snake alloc] initWithLayer:self];

    dtTick = 0.0;
    
    [self schedule:@selector(update:)];

	}
	return self;
}

- (void) setupMenu 
{
  CCMenu * mainMenu = [CCMenu menuWithItems:nil];
  
  CCMenuItemImage *quitButton = [CCMenuItemImage itemFromNormalImage:@"quitButton.png"
                                                       selectedImage:@"quitButtonSelected.png"
                                                              target:self
                                                            selector:@selector(quitGame)];
  [mainMenu addChild:quitButton];
  
  CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pauseButton.png"
                                                       selectedImage:@"pauseButtonSelected.png"
                                                              target:nil
                                                            selector:nil];
  
  CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"playResumeButton.png"
                                                        selectedImage:@"playResumeButtonSelected.png"
                                                               target:nil
                                                             selector:nil];
  
  CCMenuItemToggle *pauseToggle = [CCMenuItemToggle itemWithTarget:self 
                                                          selector:@selector(pauseGame) 
                                                             items:pauseButton, resumeButton, nil];
  
  [mainMenu addChild:pauseToggle];
  [mainMenu alignItemsHorizontallyWithPadding:184.0];
  mainMenu.position = ccp(160, 26);
  
  [self addChild:mainMenu];
}

- (void) setupDPad
{
  CCMenuItemImage *downButton = [CCMenuItemImage itemFromNormalImage:@"dpadDownButton.png"
                                                       selectedImage:@"dpadDownButtonSelected.png"
                                                              target:self
                                                            selector:@selector(turnDown)];
  
  CCMenuItemImage *upButton = [CCMenuItemImage itemFromNormalImage:@"dpadUpButton.png"
                                                     selectedImage:@"dpadUpButtonSelected.png"
                                                            target:self
                                                          selector:@selector(turnUp)];
  
  CCMenu *dpadVertical = [CCMenu menuWithItems:upButton, downButton, nil];
  [dpadVertical alignItemsVerticallyWithPadding:5.0];
  dpadVertical.position = ccp(160, 48);
  
  [self addChild:dpadVertical];
  
  CCMenuItemImage *leftButton = [CCMenuItemImage itemFromNormalImage:@"dpadLeftButton.png"
                                                       selectedImage:@"dpadLeftButtonSelected.png"
                                                              target:self
                                                            selector:@selector(turnLeft)];
  
  CCMenuItemImage *rightButton = [CCMenuItemImage itemFromNormalImage:@"dpadRightButton.png"
                                                        selectedImage:@"dpadRightButtonSelected.png"
                                                               target:self
                                                             selector:@selector(turnRight)];
  
  CCMenu *dpadHorizontal = [CCMenu menuWithItems:leftButton, rightButton, nil];
  [dpadHorizontal alignItemsHorizontallyWithPadding:60];
  dpadHorizontal.position = ccp(160, 48);
  
  [self addChild:dpadHorizontal];
}

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)onEnter
{
  [super onEnter];
  [FlurryAnalytics logPageView];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
  if ([CCDirector sharedDirector].isPaused) {
    return NO;
  }
  
  touchStart = [self convertTouchToNodeSpace: touch];
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
  if ([CCDirector sharedDirector].isPaused) {
    return;
  }
  
  CGPoint location = [self convertTouchToNodeSpace:touch];
  int dx = touchStart.x - location.x;
  int dy = touchStart.y - location.y;
  int adx = abs(dx);
  int ady = abs(dy);
  
  switch(gameManager.controlMode) {
    case SKControlModeSwipe:
      // minimum finger movement must be 5 "pixels"
      if(adx < 5 && ady < 5) {
        return;
      }
      
      if(adx > ady) {
        if(snake.velocity.x == 0) {
          snake.velocity = ccp(-dx / adx, 0);
        }
      } else {
        if(snake.velocity.y == 0) {
          snake.velocity = ccp(0, -dy / ady);
        }
      }
      break;
    case SKControlModeAreaClick:
      if(location.y < 60) {
        break;
      }
      if(snake.velocity.y != 0) {
        if(location.x < 160) {
          snake.velocity = ccp(-1, 0);
        } else {
          snake.velocity = ccp(1, 0);
        }
      } else {
        if(location.y < 260) {
          snake.velocity = ccp(0, -1);
        } else {
          snake.velocity = ccp(0, 1);
        }
      }
      break;
    case SKControlModeHeadClick:
      if(snake.velocity.y != 0) {
        if (location.x < snake.head.position.x) {
          snake.velocity = ccp(-1, 0);
        } else {
          snake.velocity = ccp(1, 0);
        }
      } else {
        if (location.y < snake.head.position.y) {
          snake.velocity = ccp(0, -1);
        } else {
          snake.velocity = ccp(0, 1);
        }
      }
      break;
  }
}

- (void)turnUp
{
  if(snake.velocity.x != 0) {
    snake.velocity = ccp(0, 1);
  }
}

- (void)turnDown
{
  if(snake.velocity.x != 0) {
    snake.velocity = ccp(0, -1);
  }
}

- (void)turnLeft
{
  if(snake.velocity.y != 0) {
    snake.velocity = ccp(-1, 0);
  }
}

- (void)turnRight
{
  if(snake.velocity.y != 0) {
    snake.velocity = ccp(1, 0);
  }
}

- (void)update:(ccTime)dt 
{
  dtTick += dt;
  if(dtTick > gameManager.tickLength) {
    [snake update];
    BOOL collision = [snake checkCollisionWithSelf];
    if(!collision) {
      collision = [snake checkCollisionWithRect:bg.boundingBox];
    }
    if(collision) {
      [[GameManager getInstance] handleGameOver];
      [[CCDirector sharedDirector] replaceScene: [GameOverLayer scene]];
    }
    if([snake eatApple:apple.position]) {
      gameManager.currentScore += 42;
      [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", gameManager.currentScore]];
      [snake addPiece];
      apple.position = [self getRandomApplePosition];
      [self checkGameState];
      [FlurryAnalytics logEvent:@"Apple Eaten"];
    }
    dtTick = 0;
  }
  if(highscoreLabel) {
    if(gameManager.currentHighScore != 0) {
      highscoreLabel.visible = YES;
    }
    [highscoreLabel setString:[NSString stringWithFormat:@"High Score: %d", gameManager.currentHighScore]];
  }
}

- (CGPoint)getRandomApplePosition
{
  CGRect box = bg.boundingBox;
  box.size.width -= 4;
  box.size.height -= 4;
  box.size.width /= 10;
  box.size.height /= 10;
  box.origin.x += 7;
  box.origin.y += 7;
  CGPoint pos = ccp((arc4random() % (int)box.size.width) * 10 + box.origin.x, 
                    (arc4random() % (int)box.size.height) * 10 + box.origin.y);
  while([snake checkPosInSnake:pos] == YES) {
    pos = ccp((arc4random() % (int)box.size.width) * 10 + box.origin.x, 
              (arc4random() % (int)box.size.height) * 10 + box.origin.y);
  }
  return pos;
}

- (void)checkGameState
{
  switch (gameManager.gameMode) {
    case SKGameModeProgressive:
      gameManager.tickLength = gameManager.tickLength * 0.95;
      if(gameManager.tickLength < 1.0/60.0) {
        gameManager.tickLength = 1.0/60.0;
      }
      break;
    default:
      break;
  }
}

- (void)quitGame
{
  CCDirector *director = [CCDirector sharedDirector];
  [director replaceScene: [IntroMenuLayer scene]];
  if(director.isPaused) {
    [director resume];
  }
}

- (void)pauseGame
{
  CCDirector *director = [CCDirector sharedDirector];
  if(director.isPaused) {
    [director resume];
  } else {
    [director pause];
  }
}

- (void)dealloc 
{
  [bg release];
  [apple release];
  [snake release];
  [scoreLabel release];
  [highscoreLabel release];
  [super dealloc];
}

@end
