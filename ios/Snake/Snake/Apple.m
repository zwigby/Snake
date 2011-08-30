//
//  Apple.m
//  Snake
//
//  Created by Charles Key on 8/28/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "Apple.h"

@implementation Apple

- (id)initWithPosition:(CGPoint)pos;
{
  if ((self = [super initWithFile:@"apple.png"])) {
    self.position = pos;
  }
  
  return self;
}

@end
