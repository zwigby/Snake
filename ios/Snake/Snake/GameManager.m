//
//  StatManager.m
//  Snake
//
//  Created by Charles Key on 8/29/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "GameManager.h"
#import "GCManager.h"
#import "FlurryAnalytics.h"

@implementation GameManager

@synthesize currentScore;
@synthesize tickLength;
@synthesize currentHighScore;
@synthesize gameMode;

+ (GameManager *)getInstance {
  static GameManager *instance;
  @synchronized(self) {
    if(!instance) {
      instance = [[GameManager alloc] init];
    }
  }
  return instance;
}

- (id)init
{
  self = [super init];
  if (self) {
    tickLength = 0.100;
    currentScore = 0;
    gameMode = SKGameModeNormal;
  }
  
  return self;
}

- (void)handleGameOver
{
  GCManager *gcManager = [GCManager getInstance];
  if(gameMode == SKGameModeProgressive) {
    [gcManager submitProgressivScore:currentScore];
    [FlurryAnalytics endTimedEvent:@"Crescendo Game" withParameters:nil];
    return;
  }
  
  if(kSlowGameSpeed - tickLength < 0.00001) {
    [gcManager submitSlowScore:currentScore];
    [FlurryAnalytics endTimedEvent:@"Slow Game" withParameters:nil];
  } else if(kMediumGameSpeed - tickLength < 0.00001) {
    [gcManager submitMediumScore:currentScore];
    [FlurryAnalytics endTimedEvent:@"Medium Game" withParameters:nil];
  } else if(kFastGameSpeed - tickLength < 0.00001) {
    [gcManager submitFastScore:currentScore];
    [FlurryAnalytics endTimedEvent:@"Fast Game" withParameters:nil];
  }
}

- (void)showLeaderboard
{
  GCManager *gcManager = [GCManager getInstance];
  if(gameMode == SKGameModeProgressive) {
    [gcManager showLeaderboard:kProgressivLeaderboardId];
    return;
  }
  
  if(kSlowGameSpeed - tickLength < 0.00001) {
    [gcManager showLeaderboard:kSlowLeaderboardId];
  } else if(kMediumGameSpeed - tickLength < 0.00001) {
    [gcManager showLeaderboard:kMediumLeaderboardId];
  } else if(kFastGameSpeed - tickLength < 0.00001) {
    [gcManager showLeaderboard:kFastLeaderboardId];
  }
}

- (void)handleGameReplay
{
  if(gameMode == SKGameModeProgressive) {
    tickLength = kSlowGameSpeed;
    [FlurryAnalytics logEvent:@"Crescendo Game" timed:YES];
    return;
  }
  
  if(kSlowGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics logEvent:@"Slow Game" timed:YES];
  } else if(kMediumGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics logEvent:@"Medium Game" timed:YES];
  } else if(kFastGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics logEvent:@"Fast Game" timed:YES];
  }
}

- (int64_t)getHighScore
{
  GCManager *gcManager = [GCManager getInstance];
  
  if(gameMode == SKGameModeProgressive) {
    return [gcManager getProgressiveHighScore];
  }
  
  if(kSlowGameSpeed - tickLength < 0.00001) {
    return [gcManager getSlowHighScore];
  } else if(kMediumGameSpeed - tickLength < 0.00001) {
    return [gcManager getMediumHighScore];
  } else if(kFastGameSpeed - tickLength < 0.00001) {
    return [gcManager getFastHighScore];
  }
  return 0;
}

- (int64_t)currentHighScore
{
  return [GCManager getInstance].currentHighScore;
}

@end
