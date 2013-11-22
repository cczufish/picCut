//
//  ListViewController.h
//  newPost
//
//  Created by YuShuHui on 13-9-26.
//  Copyright (c) 2013年 tiboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain)NSArray *dataArray;
@property(nonatomic, assign)BOOL isLev1;

@end
