//
//  UIView+MF.m
//  MFTextAttachmentView
//
//  Created by Mac on 2018/6/29.
//  Copyright © 2018年 MF. All rights reserved.
//

#import "UIView+MF.h"

@implementation UIView (MF)

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)height{
    return self.frame.size.height;
}
- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}


- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
}

- (UIImage *)capture{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(270, self.bounds.size.height), self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
