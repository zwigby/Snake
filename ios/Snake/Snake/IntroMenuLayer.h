//
//  IntroMenuLayer.h
//  Snake
//
//  Created by Charles Key on 8/25/11.
//  Copyright Paranoid Ferret Productions 2011. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// IntroMenuLayer
@interface IntroMenuLayer : CCLayerColor
{
}

// returns a CCScene that contains the IntroMenuLayer as the only child
+ (CCScene *) scene;

- (void)setupMainMenu;
- (void)setupSecondaryMenu;

@end
