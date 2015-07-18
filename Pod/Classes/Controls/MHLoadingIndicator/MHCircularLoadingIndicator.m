//
//  RKiOS7Loading.m
//  iOS7StyleLoading
//
//  Created by raj on 15/12/13.
//  Copyright (c) 2013 iPhone. All rights reserved.
//

#import "MHCircularLoadingIndicator.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <KVOController/FBKVOController.h>
#import <KVOController/NSObject+FBKVOController.h>

static const CGFloat kHudSize = 25.0f;


@interface MHCircularLoadingIndicator ()

@property (strong, nonatomic) CAShapeLayer* progressBackgroundLayer;

@end


@implementation MHCircularLoadingIndicator

// To add the iOS7 Loading on to screen
+ (id)showLoadingIndicatorOnView:(UIView*)view
{
    MHCircularLoadingIndicator* hud = [self HUDForView:view];
    if (!hud) {
        hud = [[MHCircularLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, kHudSize, kHudSize)];
        
        [view addSubview:hud];
        
        __weak typeof(hud) weakHud = hud;

        [hud.KVOController observeOnMainThread:view
                           keyPath:@"frame"
                           options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             block:^(id observer, id object, NSDictionary* change) {
                                 [weakHud update];
                             }];
    }
    
  	hud.hidden = NO;
    [hud start];
    
	return hud;
}

+ (BOOL)hideLoadingIndicatorOnView:(UIView*)view
{
	MHCircularLoadingIndicator* hud = [MHCircularLoadingIndicator HUDForView:view];
    [hud stop];
	if (hud) {
        [hud removeFromSuperview];
		return YES;
	}
	return NO;
}

+ (MHCircularLoadingIndicator*)HUDForView:(UIView*)view
{
	for (UIView* aView in view.subviews) {
		if ([aView isKindOfClass:[MHCircularLoadingIndicator class]]) {
			return (MHCircularLoadingIndicator*)aView;
		}
	}
	return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    // To set the background color of the UIView and default is clear color
    // Add more color if you wish to have
    self.backgroundColor = [UIColor clearColor];
    // Customise the Width of the cirle line and get the max of two
    _lineWidth = 1;
    
    //Round progress View
    _progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.strokeColor = self.tintColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressBackgroundLayer];
}

- (void)drawRect:(CGRect)rect
{
    self.progressBackgroundLayer.strokeColor = self.tintColor.CGColor;
    self.progressBackgroundLayer.lineWidth = self.lineWidth;
    
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
}

#pragma mark - Properties

- (void)setVerticalOffset:(CGFloat)verticalOffset
{
    _verticalOffset = verticalOffset;
    [self update];
}

#pragma mark - Drawing

- (void)drawBackgroundCircle:(BOOL)partial
{
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (self.bounds.size.width - self.lineWidth) / 2;
    
    // Draw background
    UIBezierPath* processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = self.lineWidth;
    
    // Recompute the end angle to make it at 90% of the progress
    if (partial) {
        endAngle = (1.8F * (float)M_PI) + startAngle;
    }
    
    [processBackgroundPath addArcWithCenter:center
                                     radius:radius
                                 startAngle:startAngle
                                   endAngle:endAngle
                                  clockwise:YES];
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}

- (void)update
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.superview.bounds),
                                 CGRectGetMidY(self.superview.bounds) + self.verticalOffset);
    self.center = center;
}

- (void)start
{
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(float)M_PI * 2.0f];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_progressBackgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop
{
    [self drawBackgroundCircle:NO];
    [_progressBackgroundLayer removeAllAnimations];
}

@end
