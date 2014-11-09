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
CCNode *_levelnode;
CCActionFollow *follow;

}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelnode addChild:level];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self launchPenguin];
}

- (void) update:(CCTime)delta {
    [follow step:delta];
}

- (void)launchPenguin {
    CCNode *penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_catapultarm.position, ccp(16, 140));
    [_physicsnode addChild:penguin];
    
    CGPoint direction = ccp(1, 0);
    CGPoint force = ccpMult(direction, 8000);
    [penguin.physicsBody applyForce:force];
    
    self.position = ccp(0,0);
    follow = [CCActionFollow actionWithTarget:penguin
                                worldBoundary:self.boundingBox];
}

@end
