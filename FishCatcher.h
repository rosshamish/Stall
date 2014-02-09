//
//  FishCatcher.h
//  StallLauncher
//
//  Created by Ross Anderson on 2/9/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface FishCatcher : CCNode

@property (nonatomic, assign) CCNode *_physicsNode;
@property (nonatomic, assign) bool doneGame;
@property (nonatomic, assign) bool initialized;

@end
