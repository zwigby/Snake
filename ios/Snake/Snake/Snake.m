//
//  Snake.m
//  Snake
//
//  Created by Charles Key on 8/27/11.
//  Copyright 2011 Paranoid Ferret Productions. All rights reserved.
//

#import "Snake.h"

#import "SnakePiece.h"

@implementation Snake

@synthesize velocity;

// Init as a 3 length snake
- (id)initWithLayer:(CCLayer *)layer
{
  if ((self = [super init])) {
    parent = layer;
    velocity = ccp(0, 1);
    head = tail = [[SnakePiece alloc] initWithPrev:nil andPos:ccp(165, 240)];
    [parent addChild:head];
    [self addPiece];
    [self addPiece];
    [self addPiece];
  }
  
  return self;
}

- (void)addPiece {
  SnakePiece *newTail = [[SnakePiece alloc] initWithPrev:tail andPos:tail.position];
  tail.next = newTail;
  tail = newTail;
  [parent addChild:tail];
}

- (void)destroySnake {
  SnakePiece *node = head;
  while(node) {
    [parent removeChild:node cleanup:YES];
    node = node.next;
  }
}

- (void)update 
{
  SnakePiece *node = tail;
  while(node.prev) {
    [node update];
    node = node.prev;
  }
  head.position = ccp(head.position.x + velocity.x * 10, head.position.y + velocity.y * 10);
}

- (BOOL)checkCollisionWithSelf
{
  BOOL collision = NO;
  SnakePiece *node = head.next;
  while(node) {
    if(ccpFuzzyEqual(head.position, node.position, 0.0002)) {
      collision = YES;
      break;
    }
    node = node.next;
  }
  return collision;
}

- (BOOL)checkCollisionWithRect:(CGRect)rect
{
  if(head.position.x <= rect.origin.x || head.position.x >= rect.origin.x + rect.size.width ||
     head.position.y <= rect.origin.y || head.position.y >= rect.origin.y + rect.size.height) {
    return YES;
  }
  return NO;
}

- (BOOL)eatApple:(CGPoint)pos
{
  if(ccpFuzzyEqual(pos, head.position, 0.0002))
  {
    return YES;
  }
  return NO;
}

- (BOOL)checkPosInSnake:(CGPoint)pos
{
  SnakePiece *node = head;
  while(node) {
    if(ccpFuzzyEqual(pos, node.position, 0.0002)) {
      return YES;
    }
    node = node.next;
  }
  return NO;
}

- (void)dealloc 
{
  if(head != tail) {
    [tail release];
  }
  [head release];
  [super dealloc];
}

@end
