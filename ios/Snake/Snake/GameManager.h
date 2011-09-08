//
//  StatManager.h
//  Snake
//
//  Created by Charles Key on 8/29/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

// Game speed defines
#define kSlowGameSpeed      0.2
#define kMediumGameSpeed    0.1
#define kFastGameSpeed      0.04

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameManager : NSObject
{
  int64_t currentScore;
  ccTime tickLength;
}

+ (GameManager *)getInstance;

@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, assign) ccTime tickLength;

- (void)handleGameOver;
- (void)showLeaderboard;

@end
