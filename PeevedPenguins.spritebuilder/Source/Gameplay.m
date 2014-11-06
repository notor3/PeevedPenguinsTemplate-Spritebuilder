//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Bartłomiej Pater on 07.11.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {

CCPhysicsNode *_physicsnode;
CCNode *_catapultarm;

}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self launchPenguin];
}

- (void)launchPenguin {
    CCNode *penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_catapultarm.position, ccp(16, 100));
    [_physicsnode addChild:penguin];
    
    CGPoint direction = ccp(1, 0);
    CGPoint force = ccpMult(direction, 8000);
    [penguin.physicsBody applyForce:force];
}

@end
