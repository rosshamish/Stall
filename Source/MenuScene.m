//
//  MenuScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MenuScene.h"

bool debug = NO;

@implementation MenuScene {
    CCSprite *_qrSprite;
}

static NSString *gameName;

@synthesize _captureSession;
@synthesize _videoPreviewLayer;

- (BOOL) startReading {
    // Set the location of the uiview
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    [_viewPreview setCenter:CGPointMake(winSize.width/2, winSize.height*2/3)];
    
    _viewPreview = [[UIView alloc] init];
    _viewPreviewWrap = [CCUIViewWrapper wrapperForUIView:_viewPreview];
    _viewPreviewWrap.contentSize = CGSizeMake(220, 220);
    _viewPreviewWrap.position = ccp(winSize.width*2/11, winSize.height*5/6);
    [self addChild:_viewPreviewWrap];
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        CCLOG(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
     
     _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metaDataObj = [metadataObjects objectAtIndex:0];
        if ([[metaDataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            CCLOG(@"%@", [metaDataObj stringValue]);
            gameName = [metaDataObj stringValue];
            [self stopReading];
            
            [self launchGameWithName:gameName];
        }
    }
}

- (void) stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [self removeChild:_viewPreviewWrap cleanup:true];
    _viewPreviewWrap = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
}

- (void) scan {
    [self startReading];
    
    /* Animate the fake "scanning" */
    /*
    // Pick a game randomly
    NSArray *gameNames = [NSArray arrayWithObjects:
                          @"PopTheBalloon",
                          @"FishCatcher",
                          nil];
    uint32_t rnd = arc4random_uniform([gameNames count]);
    NSString *pickedGame = [gameNames objectAtIndex:rnd];
    
    if (debug) pickedGame = [gameNames objectAtIndex:1];
    CCLOG(@"Randomly selected game: %@", pickedGame);
    
    // Fade in the qr image to a "scanned" image
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:2.0f];
    [_qrSprite runAction:fadeIn];
    [_qrSprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"qrcode.png"]];
    */
}

- (void) launchGameWithName:(NSString *)gameName {
    CCLOG(@"Trying to launch game by parameter name:%@", gameName);
    
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
