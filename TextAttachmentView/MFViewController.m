//
//  ViewController.m
//  MFTextAttachmentView
//
//  Created by Mac on 2018/6/29.
//  Copyright © 2018年 MF. All rights reserved.
//

#import "MFViewController.h"
#import "MFTextAttachmentView.h"

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define stagesPaymentContentArray @[@"装货前",@"装货后",@"卸货前",@"卸货后"]
#define cellHeight 90

@interface MFViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
/**编辑区内容*/
@property (nonatomic,retain) NSMutableArray *attachmentEditContents;
/**默认内容+编辑区内容*/
@property (nonatomic,retain) NSMutableArray *attachmentContents;

@end

@implementation MFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(getAttachmentViewContent)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)attachmentContents {
    if (!_attachmentContents) {
        _attachmentContents = [[NSMutableArray alloc] init];
    }
    return _attachmentContents;
}

- (NSMutableArray *)attachmentEditContents {
    if (!_attachmentEditContents) {
        _attachmentEditContents = [[NSMutableArray alloc] init];
    }
    return _attachmentEditContents;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stagesPaymentContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:[[MFTextAttachmentView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-40, cellHeight)
                                                         firstText:stagesPaymentContentArray[indexPath.row]]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

//获取yylabel-content-text
- (void)getAttachmentViewContent{
    [self.attachmentContents removeAllObjects];
    [self.attachmentEditContents removeAllObjects];

    NSString *tempReplace  = @"\U0000fffc";
    for (int i=0; i<stagesPaymentContentArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        for (id view in cell.subviews) {
            if ([view isKindOfClass:[MFTextAttachmentView class]]) {
                MFTextAttachmentView *attView = (MFTextAttachmentView *)view;
                NSMutableString *string = [attView configYYTextAttachment];
                [self.attachmentContents addObject:[string stringByReplacingOccurrencesOfString:tempReplace withString:@""]];
                
                NSMutableString *editString = [attView configYYTextAttachmentEditContentIndexs];
                [self.attachmentEditContents addObject:[editString stringByReplacingOccurrencesOfString:tempReplace withString:@""]];
            }
        }
    }
    NSLog(@"%@",self.attachmentContents);
    NSLog(@"%@",self.attachmentEditContents);
}

@end
