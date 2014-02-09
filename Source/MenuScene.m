//
//  MenuScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MenuScene.h"

bool debug = TRUE;

@implementation MenuScene {
    CCSprite *_qrSprite;
}



- (void) scan {
    /* Animate the fake "scanning" */
    
    /* Pick a game randomly */
    NSArray *gameNames = [NSArray arrayWithObjects:
                          @"PopTheBalloon",
                          @"FishCatcher",
                          @"NotTheBees",
                          nil];
    uint32_t rnd = arc4random_uniform([gameNames count]);
    NSString *pickedGame = [gameNames objectAtIndex:rnd];
    
    if (debug) pickedGame = [gameNames objectAtIndex:1];
    CCLOG(@"Randomly selected game: %@", pickedGame);
    
    /* Fade in the qr image to a "scanned" image */
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:2.0f];
    [_qrSprite runAction:fadeIn];
    [_qrSprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"qrcode.png"]];
    
    [self performSelector:@selector(launchGameWithName:) withObject:pickedGame afterDelay:2.0f];
}

- (void) launchGameWithName:(NSString *)gameName {
    CCLOG(@"Trying to launch game %@", gameName);
    
    // Create the game scene
    CCScene *gameScene = [CCBReader loadAsScene:gameName];
    
    // Replace the scene with the specified game
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) goToHighscores {
    CCLOG(@"Selected 'Go to Highscores'");
    // implement later
}

@end
