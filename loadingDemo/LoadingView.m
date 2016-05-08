//
//  LoadingVIew.m
//  loadingDemo
//
//  Created by sdanke on 16/5/7.
//  Copyright © 2016年 sdanke. All rights reserved.
//

#import "LoadingView.h"

static NSString *const transformRotationKey = @"transform.rotation.z";
@interface LoadingView ()

@property (nonatomic, strong) CAShapeLayer          *outsideLayer;
@property (nonatomic, strong) CAShapeLayer          *insideLayer;
@property (nonatomic, assign) BOOL                  isAnimating;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.isAnimating = NO;
        [self configureProgressLayer];
    }
    return self;
}

- (void)configureProgressLayer {

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat lineWidth = width/15;
    CGFloat outsideRadius = width/2 - lineWidth;
    CGFloat insideRadius = width/2 - 2.5 * lineWidth;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    self.outsideLayer = ({
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.position = center;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = [UIBezierPath bezierPathWithArcCenter:center radius:outsideRadius startAngle:M_PI_4 * 7 endAngle:M_PI_4 clockwise:NO].CGPath;
        layer.lineWidth = lineWidth;
        layer.lineCap = kCALineCapRound;
        layer.actions = @{@"transform":[NSNull null]};
        [self.layer addSublayer:layer];
        layer;
    });
    
    self.insideLayer = ({
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.position = center;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = [UIBezierPath bezierPathWithArcCenter:center radius:insideRadius startAngle:M_PI_2 * 3 endAngle:M_PI clockwise:YES].CGPath;
        layer.lineWidth = lineWidth;
        layer.lineCap = kCALineCapRound;
        layer.actions = @{@"transform":[NSNull null]};
        [self.layer addSublayer:layer];
        layer;
    });
}

- (void)startLoading {
    
    if (self.isAnimating) {
        return;
    }
    [self setupAnimationWithLayer:self.outsideLayer clockwise:YES];
    [self setupAnimationWithLayer:self.insideLayer clockwise:NO];
    self.isAnimating = YES;

}

- (void)setupAnimationWithLayer:(CAShapeLayer *)layer clockwise:(BOOL)isClockwise {
    
    CGFloat curDegree = (CGFloat)[[layer valueForKeyPath:transformRotationKey] doubleValue];
    CGFloat toDegree;
    if (isClockwise) {
        toDegree = curDegree + M_PI * 2;
    } else {
        toDegree = curDegree - M_PI * 2;
    }
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:transformRotationKey];
    rotationAnimation.toValue = @(toDegree);
    rotationAnimation.duration = 1.5;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:rotationAnimation forKey:@"rotateAnim"];
}

- (void)stopLoading {

    if (!self.isAnimating) {
        return;
    }
    self.isAnimating = NO;
    [self.outsideLayer removeAllAnimations];
    [self.insideLayer removeAllAnimations];
    
    [self saveCurrentStateForLayer:self.outsideLayer];
    [self saveCurrentStateForLayer:self.insideLayer];
    NSLog(@"anchor:%@", NSStringFromCGPoint(self.outsideLayer.anchorPoint));
}

- (void)saveCurrentStateForLayer:(CAShapeLayer *)layer {
    
//    CATransform3D curT = [[layer.presentationLayer valueForKey:@"transform"] CATransform3DValue];
//    layer.transform = curT;
    CGFloat curDegree = (CGFloat)[[layer.presentationLayer valueForKeyPath:transformRotationKey] doubleValue];
    [layer setValue:@(curDegree) forKeyPath:transformRotationKey];
    
}

@end
