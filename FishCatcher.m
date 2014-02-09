//
//  FishCatcher.m
//  StallLauncher
//
//  Created by Ross Anderson on 2/9/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FishCatcher.h"

@implementation FishCatcher

@synthesize _physicsNode;
@synthesize doneGame;
@synthesize initialized;

- (void) update:(CCTime)delta {
    if (!initialized) {
        initialized = true;
        [self schedule:@selector(launchFish) interval:0.4f];
    }
}

- (void) launchFish {
    CCNode *fish = [CCBReader load:@"Fish" owner:self];
    fish.position = CGPointMake(0, -67);
    [_physicsNode addChild:fish];
    CGPoint direction = CGPointMake(0.1 + arc4random_uniform(1), 0.1 + arc4random_uniform(1));
    CGPoint force = ccpMult(direction, 20000);
    [fish.physicsBody applyForce:force];
}

- (void) recordHighscore:(int)score {
    // do something intelligent here
}

- (void) endGame {
    // Return back to menu
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MenuScene"]];
}

- (void) displayScore {
    int iScore = 1000; // calculate score
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d", iScore];
    CCLabelTTF *score = [CCLabelTTF labelWithString:scoreString fontName:@"Palatino Roman" fontSize:64];
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    CGPoint pos = CGPointMake(winSize.width/2, winSize.height/5);
    [score setPosition:pos];
    [self addChild:score];
    
    [self performSelector:@selector(recordHighscore:) withObject:score];
    [self scheduleOnce:@selector(endGame) delay:2.0f];
}


@end
