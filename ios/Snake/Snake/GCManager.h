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
#define kProgressivLeaderboardId  @"4"

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GCManager : NSObject <GKLeaderboardViewControllerDelegate>
{
  UIViewController *tempVC;
  BOOL userAuthenticated;
}

@property (nonatomic, readonly) BOOL gameCenterAvailable;
@property (nonatomic, readonly) int64_t currentHighScore;

+ (GCManager *)getInstance;

- (BOOL)isGameCenterAvailable;
- (void)authenticateLocalUser;

- (void)submitScore:(int64_t)score withLeaderboard:(NSString *)leaderboard;
- (void)submitSlowScore:(int64_t)score;
- (void)submitMediumScore:(int64_t)score;
- (void)submitFastScore:(int64_t)score;
- (void)submitProgressivScore:(int64_t)score;
- (int64_t)getHighScore:(NSString *)leaderboardType;
- (int64_t)getSlowHighScore;
- (int64_t)getMediumHighScore;
- (int64_t)getFastHighScore;
- (int64_t)getProgressiveHighScore;
- (void)showLeaderboard:(NSString *)category;

@end
