//
//  ZSYPopoverListView.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat ZSYCustomButtonHeight = 40;

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

static const char * const kZSYPopoverListButtonClickForDone = "kZSYPopoverListButtonClickForDone";

@interface ZSYPopoverListView ()
@property (nonatomic, retain) UITableView *mainPopoverListView;                 //主的选择列表视图
@property (nonatomic, retain) UIButton *doneButton;                             //确定选择按钮
@property (nonatomic, retain) UIButton *cancelButton;                           //取消选择按钮
//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation ZSYPopoverListView
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize mainPopoverListView = _mainPopoverListView;
@synthesize doneButton = _doneButton;
@synthesize cancelButton = _cancelButton;
@synthesize titleName = _titleName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleName.font = [UIFont systemFontOfSize:17.0f];
    self.titleName.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    self.titleName.textAlignment = NSTextAlignmentCenter;
    self.titleName.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    self.titleName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleName.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:self.titleName];
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height-32.0f);
    _mainPopoverListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.mainPopoverListView.dataSource = self;
    self.mainPopoverListView.delegate = self;
    self.mainPopoverListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.mainPopoverListView];
}

- (void)refreshTheUserInterface
{
    if (self.cancelButton || self.doneButton)
    {
        self.mainPopoverListView.frame = CGRectMake(0, 32.0f, self.mainPopoverListView.frame.size.width, self.mainPopoverListView.frame.size.height);
    }
    if (self.doneButton && nil == self.cancelButton)
    {
        self.cancelButton.frame = CGRectMake(5, self.bounds.size.height - 2*ZSYCustomButtonHeight+10, self.bounds.size.width-5, ZSYCustomButtonHeight);
    }
    else if (nil == self.doneButton && self.cancelButton)
    {
        self.doneButton.frame = CGRectMake(0, self.bounds.size.height - 2*ZSYCustomButtonHeight+10, self.bounds.size.width-5, ZSYCustomButtonHeight);
        
    }
    else if (self.doneButton && self.cancelButton)
    {
        self.cancelButton.frame = CGRectMake(5, self.bounds.size.height - 2*ZSYCustomButtonHeight+10, self.bounds.size.width / 2.0f-10, ZSYCustomButtonHeight);
        self.doneButton.frame = CGRectMake(self.bounds.size.width / 2.0f+5, self.bounds.size.height - 2*ZSYCustomButtonHeight+10, self.bounds.size.width / 2.0f-10, ZSYCustomButtonHeight);
    }
    
}

- (NSIndexPath *)indexPathForSelectedRow
{
    return [self.mainPopoverListView indexPathForSelectedRow];
}
#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:cellForRowAtIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didSelectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
    
    
}

#pragma mark - show or hide self
- (void)show
{
    [self refreshTheUserInterface];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Reuse Cycle
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier
{
    return [self.mainPopoverListView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mainPopoverListView cellForRowAtIndexPath:indexPath];
}




#pragma mark - Button Method
- (void)setCancelButtonTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.cancelButton.tag = 101;
        
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    [self.cancelButton setTitle:aTitle forState:UIControlStateNormal];
   
}

- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _doneButton)
    {
        self.doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.doneButton.tag = 102;
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
    }
    [self.doneButton setTitle:aTitle forState:UIControlStateNormal];
   
}
#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    UIButton *btn = (UIButton * )sender;
    
    if (btn.tag == 101) {
        [self animatedOut];
    }else{
        [self animatedIn];
    }
}
@end
