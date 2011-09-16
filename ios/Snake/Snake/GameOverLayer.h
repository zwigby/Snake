//
//  GameOverLayer.h
//  Snake
//
//  Created by Charles Key on 8/28/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface GameOverLayer : CCLayerColor

// returns a CCScene that contains the GameOverLayer as the only child
+ (CCScene *) scene;

- (void)setupMenu;

@end
