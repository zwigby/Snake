//
//  GCManager.m
//  Snake
//
//  Created by Charles Key on 9/6/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "GCManager.h"

@implementation GCManager

@synthesize gameCenterAvailable = _gameCenterAvailable;
@synthesize currentHighScore = _currentHighScore;

+ (GCManager *)getInstance {
  static GCManager *instance;
  @synchronized(self) {
    if(!instance) {
      instance = [[GCManager alloc] init];
    }
  }
  return instance;
}

- (id)init
{
  self = [super init];
  if (self) {
    _gameCenterAvailable = [self isGameCenterAvailable];
    if(_gameCenterAvailable) {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self 
             selector:@selector(authenticationChanged) 
                 name:GKPlayerAuthenticationDidChangeNotificationName 
               object:nil];
    }
    
    // Temp VC for Game Center Stuff
    tempVC = [[UIViewController alloc] init];
  }
    
  return self;
}

- (BOOL)isGameCenterAvailable
{
  // check for GKLocalPlayerAPI
  Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
  
  // check if the device is running iOS 4.1 or later
  NSString *reqSysVer = @"4.1";
  NSString *curSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osSupported = ([curSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  
  return (gcClass && osSupported);
}

- (void)authenticationChanged 
{
  if([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
    userAuthenticated = YES;
  } else if(![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
    userAuthenticated = NO;
  }
}

- (void)authenticateLocalUser
{
  if(!_gameCenterAvailable) {
    return;
  }
  
  if([GKLocalPlayer localPlayer].authenticated == NO) {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
  }
}

- (void)submitScore:(int64_t)score withLeaderboard:(NSString *)leaderboard
{
  if(!_gameCenterAvailable) {
    return;
  }
  
  GKScore *newScore = [[GKScore alloc] initWithCategory:leaderboard];
  newScore.value = score;
  
  [newScore reportScoreWithCompletionHandler:nil];
}

- (void)submitSlowScore:(int64_t)score
{
  [self submitScore:score withLeaderboard:kSlowLeaderboardId];
}

- (void)submitMediumScore:(int64_t)score
{
  [self submitScore:score withLeaderboard:kMediumLeaderboardId];
}

- (void)submitFastScore:(int64_t)score
{
  [self submitScore:score withLeaderboard:kFastLeaderboardId];
}

- (int64_t)getHighScore:(NSString *)leaderboardType
{
  if(!_gameCenterAvailable) {
    return -1;
  }
  
  GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
  
  if (leaderboardRequest != nil)
  {
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
    leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderboardRequest.range = NSMakeRange(1,1);
    leaderboardRequest.category = leaderboardType;
    [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
      if (error != nil)
      {
        // handle the error.
      }
      if (scores != nil)
      {
        GKScore *topScore = [scores objectAtIndex:0];
        _currentHighScore = topScore.value;
      }
    }];
  }
  
  return _currentHighScore;
}

- (int64_t)getSlowHighScore
{
  return [self getHighScore:kSlowLeaderboardId];
}

- (int64_t)getMediumHighScore
{
  return [self getHighScore:kMediumLeaderboardId];
}

- (int64_t)getFastHighScore
{
  return [self getHighScore:kFastLeaderboardId];
}

- (void)showLeaderboard:(NSString *)category
{
  if(!_gameCenterAvailable) {
    return;
  }
  
  GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
  if (leaderboardController != nil)
  {
    leaderboardController.leaderboardDelegate = self;
    leaderboardController.category = category;
    [[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
    [tempVC presentModalViewController:leaderboardController animated: YES];
    
  }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [tempVC dismissModalViewControllerAnimated:YES];
  [tempVC.view removeFromSuperview];
}

- (void)dealloc
{
  [tempVC release];
  [super dealloc];
}

@end
