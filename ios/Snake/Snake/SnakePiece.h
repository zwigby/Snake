//
//  Snake.h
//  Snake
//
//  Created by Charles Key on 8/27/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "cocos2d.h"

@interface SnakePiece : CCSprite
{
  SnakePiece *prev;
  SnakePiece *next;
}

@property (nonatomic, retain) SnakePiece *prev;
@property (nonatomic, retain) SnakePiece *next;

- (id)initWithPrev:(SnakePiece *)previous andPos:(CGPoint)pos;
- (void)update;
@end
