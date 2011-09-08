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
  }
  
  return self;
}

- (void)handleGameOver
{
  GCManager *gcManager = [GCManager getInstance];
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
  if(kSlowGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics endTimedEvent:@"Slow Game" withParameters:nil];
  } else if(kMediumGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics endTimedEvent:@"Medium Game" withParameters:nil];
  } else if(kFastGameSpeed - tickLength < 0.00001) {
    [FlurryAnalytics endTimedEvent:@"Fast Game" withParameters:nil];
  }
}

@end
