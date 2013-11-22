//
//  ViewController.m
//  newPost
//
//  Created by YuShuHui on 13-9-25.
//  Copyright (c) 2013年 tiboo. All rights reserved.
//

#import "ViewController.h"
#import "postViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.view.bounds = CGRectMake(0, -20, 320, self.view.frame.size.height);
        
    }
    
    
    self.title = @"师说堂";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:@"提问" style:UIBarButtonItemStyleBordered target:self action:@selector(doPost)];
    self.navigationItem.rightBarButtonItem = postBtn;
}
- (void)doPost{
    
    postViewController *VieContro = [[postViewController alloc] init];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"后退";
  
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:VieContro animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
