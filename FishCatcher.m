//
//  FishCatcher.m
//  StallLauncher
//
//  Created by Ross Anderson on 2/9/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FishCatcher.h"

@implementation FishCatcher

static NSInteger score;
static float startTime;
static CCLabelTTF *timeLabel;
static CCLabelTTF *scoreLabel;
static bool gameEnding = false;

@synthesize _physicsNode;
@synthesize doneGame;
@synthesize initialized;
@synthesize fishes;

- (void) update:(CCTime)delta {
    if (!initialized) {
        initialized = true;
        gameEnding = false;
        
        // Enable touches
        [self setUserInteractionEnabled:TRUE];
        
        // init fishes array
        fishes = [NSMutableArray arrayWithObjects: nil];
        
        // Default score + timer values
        score = 0;
        startTime = CFAbsoluteTimeGetCurrent();
        
        // Add timelabel
        timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", (int)(startTime / 1000)] fontName:@"Palatino-Roman" fontSize:30];
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        timeLabel.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:timeLabel];
        
        // ADD SCORELABEL
        [self displayScore];
        
        // schedule fish launching
        [self schedule:@selector(launchFish) interval:1.5f];
    }
    // Update time remaining
    CCLOG(@"%f", (CFAbsoluteTimeGetCurrent() - startTime) / 1000);
    startTime--;
    float time = 10 - (CFAbsoluteTimeGetCurrent() - startTime);
    
    if (time <= 0.0) {
        [timeLabel setString:@""];
        [self recordHighscore:score];
        if (!gameEnding) {
            gameEnding = true;
            [self scheduleOnce:@selector(endGame) delay:2.0f];
        }
    } else {
        [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
        [timeLabel setString:[NSString stringWithFormat:@"%1.1f", time]];
    }
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CCLOG(@"Caught touch!");
    CGPoint loc = [touch locationInView: [touch view]];
    loc = [[CCDirector sharedDirector] convertToGL:loc];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (CCNode* fish in fishes) {
        CGRect box = fish.boundingBox;
        if (CGRectContainsPoint(box, loc)) {
            CCLOG(@"Fish caught");
            [toRemove addObject:fish];
            [fish removeFromParent];
            score++;
        }
    }
    for (CCNode *rm in toRemove) {
        [fishes removeObject:rm];
    }
    toRemove = nil;
}

- (void) launchFish {
    CCLOG(@"Launching fish!");
    CCNode *fish = [CCBReader load:@"Fish" owner:self];
    fish.position = CGPointMake(0, 0);
    [_physicsNode addChild:fish];
    
    CGPoint direction = CGPointMake(0.1 + (arc4random_uniform(6) / 10.0), 0.5 + (arc4random_uniform(10) / 10.0));
    CGPoint force = ccpMult(direction, 200000);
    [fish.physicsBody applyForce:force];
    [fishes addObject:fish];
    
    // Deal with fish cleanup
    NSMutableArray *toRemove = [NSMutableArray array];
    for (CCNode *_fish in fishes) {
        if (_fish.physicsBody.velocity.y < 0) {
            if (_fish.position.y < -20) {
                CCLOG(@"killed a fish");
                [toRemove addObject:_fish];
                [_fish removeFromParent];
            }
        }
    }
    for (CCNode *rm in toRemove) {
        [fishes removeObject:rm];
    }
    toRemove = nil;
}

- (void) recordHighscore:(int)score {
    // do something intelligent here
}

- (void) endGame {
    // Return back to menu
    initialized = FALSE;
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MenuScene"]];
}

- (void) displayScore {
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d", score];
    scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Palatino-Roman" fontSize:64];
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    CGPoint pos = CGPointMake(winSize.width/2, winSize.height/5);
    [scoreLabel setPosition:pos];
    [self addChild:scoreLabel];
}


@end
