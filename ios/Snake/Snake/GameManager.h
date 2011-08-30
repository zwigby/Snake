//
//  StatManager.h
//  Snake
//
//  Created by Charles Key on 8/29/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameManager : NSObject
{
  int currentScore;
  ccTime tickLength;
}

+ (GameManager *)getInstance;

@property (nonatomic, assign) int currentScore;
@property (nonatomic, assign) ccTime tickLength;

@end
