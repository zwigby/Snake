//
//  CCRadioMenu.h
//  Snake
//
//  Created by Charles Key on 10/22/11.
//  Copyright (c) 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "cocos2d.h"

@interface CCRadioMenu : CCMenu {
	int selectedItemIndex;
	int fallBackItemIndex;
}

@property int selectedItemIndex;

-(CCMenuItem *) itemForTouch: (UITouch *) touch;

@end

