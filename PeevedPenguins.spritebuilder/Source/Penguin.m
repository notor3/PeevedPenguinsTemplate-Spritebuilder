//
//  Penguin.m
//  PeevedPenguins
//
//  Created by Bartłomiej Pater on 01.11.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Penguin.h"

@implementation Penguin

-(void)loadFromCCB {
    self.physicsBody.collisionType = @"penguin";
}

@end
