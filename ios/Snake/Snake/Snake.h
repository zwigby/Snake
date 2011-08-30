//
//  Snake.h
//  Snake
//
//  Created by Charles Key on 8/27/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SnakePiece;

@interface Snake : NSObject
{
  CGPoint velocity;
  
  SnakePiece *head;
  SnakePiece *tail;
  
  CCLayer *parent;
}

@property (nonatomic, assign) CGPoint velocity;

- (id)initWithLayer:(CCLayer *)layer;
- (void)addPiece;
- (void)update;
- (BOOL)checkCollisionWithSelf;
- (BOOL)checkCollisionWithRect:(CGRect)rect;
- (BOOL)eatApple:(CGPoint)pos;
- (BOOL)checkPosInSnake:(CGPoint)pos;

@end
