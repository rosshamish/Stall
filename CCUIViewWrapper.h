//
//  CCUIViewWrapper.h
//  StallLauncher
//
//  Credit: blue-ether on cocos2d-iphone.org
//

#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
    UIView *uiItem;
    float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end
