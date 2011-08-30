//
//  Snake.m
//  Snake
//
//  Created by Charles Key on 8/27/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "SnakePiece.h"

@implementation SnakePiece

@synthesize prev;
@synthesize next;

- (id)initWithPrev:(SnakePiece *)previous andPos:(CGPoint)pos {
  if((self = [super initWithFile:@"snake_piece.png"])) {
    self.prev = previous;
    self.position = pos;
    [self.texture setAntiAliasTexParameters];
  }
  return self;
}

- (void)update {
  if(prev) {
    self.position = prev.position;
  }
}

- (void)dealloc {
  [prev release];
  [next release];
  [super dealloc];
}

@end
