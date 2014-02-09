//
//  MenuScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CCUIViewWrapper.h"

@interface MenuScene : CCNode <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *_captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *_videoPreviewLayer;

@property (retain, nonatomic) UIView *viewPreview;
@property (retain, nonatomic) CCUIViewWrapper *viewPreviewWrap;

- (BOOL) startReading;

- (void) scan;
- (void) launchGameWithName:(NSString *)gameName;
- (void) goToHighscores;

@end