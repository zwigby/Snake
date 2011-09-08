//
//  GCManager.h
//  Snake
//
//  Created by Charles Key on 9/6/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

// Leaderboard Category IDs
#define kSlowLeaderboardId        @"1"
#define kMediumLeaderboardId      @"2"
#define kFastLeaderboardId        @"3"

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GCManager : NSObject <GKLeaderboardViewControllerDelegate>
{
  UIViewController *tempVC;
  BOOL userAuthenticated;
}

@property (nonatomic, readonly) BOOL gameCenterAvailable;

+ (GCManager *)getInstance;

- (BOOL)isGameCenterAvailable;
- (void)authenticateLocalUser;

- (void)submitScore:(int64_t)score withLeaderboard:(NSString *)leaderboard;
- (void)submitSlowScore:(int64_t)score;
- (void)submitMediumScore:(int64_t)score;
- (void)submitFastScore:(int64_t)score;
- (void)showLeaderboard:(NSString *)category;

@end
