//
//  PopTheBalloon.m
//  StallLauncher
//
//  Created by Ross Anderson on 2/8/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PopTheBalloon.h"

@implementation PopTheBalloon

@synthesize _balloon;
@synthesize times_inflated;
@synthesize startTime;
@synthesize doneGame;

- (void) update:(CCTime)delta {
    CCLOG(@"%f", [_balloon scaleX]);
}

- (void) recordHighscore:(int)score {
    // do something intelligent here
}

- (void) endGame {
    // Return back to menu
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MenuScene"]];
}

- (void) letAirOut {
    [_balloon runAction:[CCActionScaleBy actionWithDuration:0.5f scale:0.8]];
}

- (void) displayScore {
    int iScore = ( 100 - (CFAbsoluteTimeGetCurrent() - startTime) * 10);
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d", iScore];
    CCLabelTTF *score = [CCLabelTTF labelWithString:scoreString fontName:@"Palatino Roman" fontSize:64];
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    CGPoint pos = CGPointMake(winSize.width/2, winSize.height/5);
    [score setPosition:pos];
    [self addChild:score];
    
    [self performSelector:@selector(recordHighscore:) withObject:score];
    [self scheduleOnce:@selector(endGame) delay:2.0f];
}

- (void) inflate {
    CCLOG(@"Trying to inflate! Inflated %d time", times_inflated+1);
    if (times_inflated <= 0) {
        /* Schedule deflating */
        [self schedule:@selector(letAirOut) interval:0.5f];
        
        doneGame = false;
        
        startTime = CFAbsoluteTimeGetCurrent();
    }
    times_inflated++;
    
    if ([_balloon scaleX] > 4.0 && !doneGame) {
        // Done game
        CCLOG(@"POP!!");
        doneGame = true;
        
        // Deflate the balloon
        id deflate = [CCActionEaseElasticIn actionWithAction:[CCActionScaleTo actionWithDuration:2.0f scale:0.0f]];
        [_balloon runAction:deflate];
        
        // Create the "popped!" label
        CCLabelTTF *doneNotification = [CCLabelTTF labelWithString:@"Popped!" fontName:@"Palatino Roman" fontSize:40];
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        CGPoint pos = CGPointMake(winSize.width/2, winSize.height/2);
        [doneNotification setPosition:pos];
        [self addChild:doneNotification];
        
        // Show score
        [self scheduleOnce:@selector(displayScore) delay:1.0f];
        
        // Unschedule balloon deflation
        [self unschedule:@selector(letAirOut)];
    } else if (!doneGame) {
        id scaleAction = [CCActionScaleBy actionWithDuration:0.1f scaleX:1.3 scaleY:1.2];
        [_balloon stopAllActions];
        [_balloon runAction:scaleAction];
    }
    
    
}

@end
