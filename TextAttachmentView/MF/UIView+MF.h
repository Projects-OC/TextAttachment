//
//  UIView+MF.h
//  MFTextAttachmentView
//
//  Created by Mac on 2018/6/29.
//  Copyright © 2018年 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MF)

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)maxY;
- (CGFloat)maxX;

- (void)setTarget:(id)target action:(SEL)action;

- (UIImage *)capture;

@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end
