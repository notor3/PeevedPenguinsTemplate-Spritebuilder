//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Bartłomiej Pater on 07.11.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCPhysics+ObjectiveChipmunk.h"
#import "Gameplay.h"

// minimum penguin speed
static const float MIN_SPEED = 5.f;


@implementation Gameplay {
    CCPhysicsNode *_physicsnode;
    CCNode *_catapultarm;
    CCNode *_levelnode;
    CCNode *_contentNode;
    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_currentPenguin;
    CCPhysicsJoint *_penguinCatapultJoint;
	CCActionFollow *_followPenguin;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelnode addChild:level];
//    _physicsnode.debugDraw = TRUE;
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
    _physicsnode.collisionDelegate = self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    if (CGRectContainsPoint([_catapultarm boundingBox], touchLocation)) {
        _mouseJointNode.position = touchLocation;
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultarm.physicsBody anchorA:ccp(0,0) anchorB:ccp(34,138) restLength:0.0f stiffness:300.0f damping:15.0f];
        
        _currentPenguin = [CCBReader load:@"Penguin"];
        CGPoint penguinPosition = [_catapultarm convertToWorldSpace:ccp(34,138)];
        _currentPenguin.position = penguinPosition;
        [_physicsnode addChild:_currentPenguin];
        _currentPenguin.physicsBody.allowsRotation = NO;
        
        _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultarm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self releaseCatapult];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self releaseCatapult];
}

- (void)releaseCatapult {
    if (_mouseJoint != nil) {
        [_mouseJoint invalidate];
        _mouseJoint = nil;
        
        [_penguinCatapultJoint invalidate];
        _penguinCatapultJoint = nil;
        
        _currentPenguin.physicsBody.allowsRotation = YES;

	    _followPenguin = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
	    [_contentNode runAction:_followPenguin];
    }
}

- (void)retry {
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}

-(void)sealRemoved:(CCNode *)seal {
    [seal removeFromParent];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair seal:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    float energy = [pair totalKineticEnergy];
    if (energy > 5000.f) {
        [[_physicsnode space] addPostStepBlock:^{
            [self sealRemoved:nodeA];
        } key:nodeA];
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)nodeA seal:(CCNode *)nodeB {
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SealExplosion"];
//    CCParticleExplosion *explosion = [[CCParticleExplosion alloc] initWithTotalParticles:500];
    explosion.autoRemoveOnFinish = YES;
    explosion.position = nodeB.position;
    [nodeB.parent addChild:explosion];
}

- (void)update:(CCTime)delta {
    float speed = ccpLength(_currentPenguin.physicsBody.velocity);
	if (speed < MIN_SPEED && speed > 0.1f) {
        CCLOG(@"za wolno - nowy pingu %f", ccpLength(_currentPenguin.physicsBody.velocity));
		[self nextAttempt];
	}

	float xMin = _currentPenguin.boundingBox.origin.x;
	if (xMin < self.boundingBox.origin.x) {
        CCLOG(@"wyleciał w lewo - nowy pingu");
		[self nextAttempt];
		return;
	}

	float xMax = xMin + _currentPenguin.boundingBox.size.width;
	if (xMax > (self.boundingBox.origin.x + self.boundingBox.size.width)) {
        CCLOG(@"wyleciał w prawo - nowy pingu");
		[self nextAttempt];
		return;
	}
}

- (void)nextAttempt {
	_currentPenguin = nil;
	[_contentNode stopAction:_followPenguin];
	CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(0,0)];
	[_contentNode runAction:actionMoveTo];
}

@end
