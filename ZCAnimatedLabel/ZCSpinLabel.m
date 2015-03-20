//
//  ZCSpinLabel.m
//  ZCAnimatedLabel
//
//  Created by Chen Zhang on 3/17/15.
//  Copyright (c) 2015 alipay. All rights reserved.
//
//  3d transform on image doesn't seem practical in real time on images better than a dime
//  use layerBased implementation isntead
//

#import "ZCSpinLabel.h"

@implementation ZCSpinLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
        self.layerBased = YES;
    }
    return self;
}

- (void) customAttributeInit:(ZCTextBlock *)attribute
{
    if (self.layerBased) {
        ZCTextBlockLayer *layer = attribute.textBlockLayer;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.transform = CATransform3DMakeRotation((M_PI / 2), 0, 1, 0);
        [layer setNeedsDisplay];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(attribute.charRect.size, NO, [UIScreen mainScreen].scale);
        UIColor *color = [attribute.derivedTextColor colorWithAlphaComponent:1];
        attribute.textColor = color;
        [attribute.derivedAttributedString drawInRect:CGRectMake(0, 0, attribute.charRect.size.width, attribute.charRect.size.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        attribute.customValue = image;
    }
}


- (void) customViewAppearChangesForAttribute: (ZCTextBlock *) attribute
{
    if (attribute.progress <= 0) {
        return;
    }
    CGFloat realProgress = [ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:attribute.progress];
    attribute.textBlockLayer.transform = CATransform3DMakeRotation(M_PI / 2 * (1 - realProgress), 0, 1, 0);
}



@end
