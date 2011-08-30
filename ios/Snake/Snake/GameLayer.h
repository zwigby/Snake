//
//  GameLayer.h
//  Snake
//
//  Created by Charles Key on 8/25/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "cocos2d.h"

@class Snake, Apple, GameManager;

@interface GameLayer : CCLayerColor
{
  CCSprite *bg;
  Snake *snake;
  Apple *apple;
  CCLabelBMFont *scoreLabel;

  ccTime dtTick;
  
  CGPoint touchStart;
  
  GameManager *gameManager;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

- (void) setupMenu;
- (CGPoint)getRandomApplePosition;

@end
