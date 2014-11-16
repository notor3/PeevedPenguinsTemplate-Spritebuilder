//
//  Seal.m
//  PeevedPenguins
//
//  Created by Bartłomiej Pater on 01.11.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Seal.h"

@implementation Seal

-(void)didLoadFromCCB {
    self.physicsBody.collisionType = @"seal";
}

@end
