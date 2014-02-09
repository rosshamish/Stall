//
//  PopTheBalloon.h
//  StallLauncher
//
//  Created by Ross Anderson on 2/8/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface PopTheBalloon : CCNode {
    
}

@property (nonatomic, assign) NSInteger times_inflated;
@property (nonatomic, assign) CCSprite *_balloon;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) bool doneGame;


- (void) inflate;
- (void) recordHighscore:(int)score;
- (void) endGame;

@end
