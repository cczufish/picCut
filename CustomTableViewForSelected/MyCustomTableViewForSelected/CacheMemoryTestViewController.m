//
//  CacheMemoryTestViewController.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "CacheMemoryTestViewController.h"


@interface CacheMemoryTestViewController ()
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation CacheMemoryTestViewController
@synthesize selectedIndexPath = _selectedIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor redColor]];
    dataArray = [[NSArray alloc]initWithObjects:@"思路不清楚",@"答案不算对",@"题目看不懂", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
    listView.titleName.text = @"问题原因";
    listView.datasource = self;
    listView.delegate = self;
 //   listView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [listView setCancelButtonTitle:@"取消" block:^{
        NSLog(@"cancel");
    }];
    [listView setDoneButtonWithTitle:@"确认" block:^{
        NSLog(@"Ok%d", [listView indexPathForSelectedRow].row);
    }];
    [listView show];
    [listView release];
}

#pragma mark - 
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    NSLog(@"deselect:%d", indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"select:%d", indexPath.row);
}
@end
