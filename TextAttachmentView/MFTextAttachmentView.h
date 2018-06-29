//
//  MFTextAttachmentView.h
//  MFTextAttachmentView
//
//  Created by Mac on 2018/6/29.
//  Copyright © 2018年 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

@interface MFTextAttachmentView : UIView

@property (nonatomic, strong) YYLabel *label;

- (instancetype)initWithFrame:(CGRect)frame firstText:(NSString *)firstText;

//获取完整的字符串
- (NSMutableString *)configYYTextAttachment;

//只获取编辑可编辑不部分（textfiled、button等）
- (NSMutableString *)configYYTextAttachmentEditContentIndexs;

@end
