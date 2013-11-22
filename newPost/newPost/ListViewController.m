//
//  ListViewController.m
//  newPost
//
//  Created by YuShuHui on 13-9-26.
//  Copyright (c) 2013年 tiboo. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize dataArray;
@synthesize isLev1;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isLev1 == YES) {
        dataArray = [[NSArray alloc] initWithObjects:@"数学",@"语文",@"英语",@"物理",@"化学", nil];
    }else{
        
        dataArray = [[NSArray alloc] initWithObjects:@"幼儿园",@"一年级",@"2年级",@"3年级",@"4年级", nil];
    }
    UITableView *listtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    listtable.dataSource = self;
    listtable.delegate = self;
    [self.view addSubview:listtable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
  
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListViewController *VieContro = [[ListViewController alloc] init];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"后退";
    
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
     VieContro.isLev1 = YES;
    [self.navigationController pushViewController:VieContro animated:YES];
    VieContro.title = @"选学科";
   
}

@end
