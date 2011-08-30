//
//  StatManager.m
//  Snake
//
//  Created by Charles Key on 8/29/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "GameManager.h"

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

@end
