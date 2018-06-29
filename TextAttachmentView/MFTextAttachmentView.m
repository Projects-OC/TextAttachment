//
//  MFTextAttachmentView.m
//  MFTextAttachmentView
//
//  Created by Mac on 2018/6/29.
//  Copyright © 2018年 MF. All rights reserved.
//

#import "MFTextAttachmentView.h"
#import "MFTextField.h"
#import "UIView+MF.h"

#define demurrageFreeDoubleWharfNum @[@"装船数量",@"卸船数量"]

@interface MFTextAttachmentView ()

@property (nonatomic,strong) NSMutableAttributedString *mutableAttributedString;
@property (nonatomic,strong) NSMutableArray *attachmentButtons;

@end

@implementation MFTextAttachmentView

- (instancetype)initWithFrame:(CGRect)frame firstText:(NSString *)firstText{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachmentText:firstText];
    }
    return self;
}

- (NSMutableArray *)attachmentButtons {
    if (!_attachmentButtons) {
        _attachmentButtons = [[NSMutableArray alloc] init];
    }
    return _attachmentButtons;
}

- (void)attachmentText:(NSString *)firstText{
    _mutableAttributedString = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:13];
 
    NSString *title = firstText;
    [_mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
    [self attachmentTextfieldWithString:@"天，从"];
    [self attachmentTextfieldWithString:@"天开始按照"];
    [self attachmentButton];
    [_mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"给予" attributes:nil]];
    [self attachmentTextfieldWithString:@"元/吨·天滞期补助"];
 
    _mutableAttributedString.yy_font = font;
    
    _label = [YYLabel new];
    _label.userInteractionEnabled = YES;
    _label.numberOfLines = 0;
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.size = CGSizeMake(self.width, self.height);
    _label.attributedText = _mutableAttributedString;
    [self addSubview:_label];
}

- (void)attachmentTextfieldWithString:(NSString *)string{
    UIFont *font = [UIFont systemFontOfSize:13];
    MFTextField *textfield = [MFTextField new];
    textfield.size = CGSizeMake(50, 20);
    textfield.font = font;
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:textfield
                                                                                          contentMode:UIViewContentModeCenter
                                                                                       attachmentSize:textfield.size
                                                                                          alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [_mutableAttributedString appendAttributedString:attachText];
    [_mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:nil]];
}

- (void)attachmentButton{
    UIFont *font = [UIFont systemFontOfSize:13];
    for (int i=0; i<2; i++) {
        UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setImage:[UIImage imageNamed:@"circle_default_status"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"circle_current_status"] forState:UIControlStateSelected];
        [_btn setTitle:demurrageFreeDoubleWharfNum[i] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag = i;
        _btn.selected = i==0 ? YES : NO;
        _btn.titleLabel.font = font;
        [_btn sizeToFit];
        [self.attachmentButtons addObject:_btn];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:_btn
                                                                                              contentMode:UIViewContentModeCenter
                                                                                           attachmentSize:_btn.size
                                                                                              alignToFont:font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [_mutableAttributedString appendAttributedString:attachText];
    }
}

- (void)btnClick:(UIButton *)btnClick{
    [self.attachmentButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([btnClick isEqual:obj]) {
            btnClick.selected = !btnClick.selected;
        }else {
            obj.selected = !obj.selected;
        }
    }];
//    NSLog(@"%@",_label.text);
}

- (NSMutableString *)configYYTextAttachmentEditContentIndexs{
    //存储资源数组
    NSMutableArray *attachmentTexts = [NSMutableArray new];
    
    //因为content中button是单选 所以去除没有选中的button内容（index就是下标）
    __block NSInteger skipIndex;
    
    //获取所有资源（button、textField等）
    NSArray *attachments =  _label.textLayout.attachments;
    [attachments enumerateObjectsUsingBlock:^(YYTextAttachment *attachment, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([attachment.content isKindOfClass:[UITextField class]]) {
            UITextField *tf = attachment.content;
            if (tf.text.length == 0) {
                tf.text = @"";
            }
            [attachmentTexts addObject:tf.text];
        }
        
        if ([attachment.content isKindOfClass:[UIButton class]]) {
            UIButton *btn = attachment.content;
            if (btn.selected) {
                NSInteger keyIndex = [demurrageFreeDoubleWharfNum indexOfObject:btn.titleLabel.text];
                [attachmentTexts addObject:[NSNumber numberWithInteger:keyIndex]];
            }else{
                skipIndex = idx;
            }
        }
    }];
    NSMutableString *indexs = [attachmentTexts componentsJoinedByString:@","].mutableCopy;
    return indexs;
}


- (NSMutableString *)configYYTextAttachment{
    //存储资源数组
    NSMutableArray *attachmentTexts = [NSMutableArray new];
    //存储资源index数组
    NSMutableArray *attachmentRangeIndexs = [NSMutableArray new];
    //因为content中button是单选 所以去除没有选中的button内容（index就是下标）
    __block NSInteger skipIndex;
    
    //获取所有资源（button、textField等）
    NSArray *attachments =  _label.textLayout.attachments;
    [attachments enumerateObjectsUsingBlock:^(YYTextAttachment *attachment, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([attachment.content isKindOfClass:[UITextField class]]) {
            UITextField *tf = attachment.content;
            if (tf.text.length == 0) {
                tf.text = @"";
            }
            [attachmentTexts addObject:tf.text];
        }
        
        if ([attachment.content isKindOfClass:[UIButton class]]) {
            UIButton *btn = attachment.content;
            if (btn.selected) {
                [attachmentTexts addObject:btn.titleLabel.text];
            }else{
                skipIndex = idx;
            }
        }
    }];
    
    //获取资源所在的位置
    NSArray *attachmentRanges = _label.textLayout.attachmentRanges;
    [attachmentRanges enumerateObjectsUsingBlock:^(NSValue  *range, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange r = [range rangeValue];
        //        NSLog(@"资源所在位置：%ld 长度: %ld",r.location,r.length);
        if (skipIndex != idx) {
            [attachmentRangeIndexs addObject:[NSNumber numberWithInteger:r.location]];
        }
    }];
    
    //在资源所在位置处 插入相应资源
    NSMutableString *mutableString = _label.text.mutableCopy;
    NSInteger length = 0;
    for (int i=0; i<attachmentTexts.count; i++) {
        [mutableString insertString:attachmentTexts[i] atIndex:[attachmentRangeIndexs[i] integerValue] + length];
        length += [attachmentTexts[i] length];
    }
    return mutableString;
}

@end
