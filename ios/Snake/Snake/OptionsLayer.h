//
//  OptionsLayer.h
//  Snake
//
//  Created by Charles Key on 10/21/11.
//  Copyright (c) 2011 Paranoid Ferret Productions. All rights reserved.
//

#define DIRECTIONAL_SWIPE_HELP @"Direction swipe means the\nsnake will go in the\ndirection of your swipe."
#define DPAD_HELP @"D-Pad means a button\ndirection pad will appear.\nThis makes the playable\ngame area smaller."
#define HEAD_CLICK_HELP @"Head click means you click\nin relation to the snake's\nhead to change direction."

#import "cocos2d.h"

@interface OptionsLayer : CCLayerColor
{
  CCLabelBMFont *helpText;
}

// returns a CCScene that contains the OptionsLayer as the only child
+ (CCScene *) scene;

- (void)setupMenu;

@end
