//
//  WaitingPenguin.m
//  PeevedPenguins
//
//  Created by Bartłomiej Pater on 17/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WaitingPenguin.h"

@implementation WaitingPenguin

-(void) didLoadFromCCB {
    float delay = (arc4random() % 2000) / 1000.f;
    [self performSelector:@selector(startPenguin) withObject:nil afterDelay:delay];
}

- (void)startPenguin {
    CCAnimationManager *am = self.animationManager;
    [am runAnimationsForSequenceNamed:@"BlinkAndJump"];
}

@end
