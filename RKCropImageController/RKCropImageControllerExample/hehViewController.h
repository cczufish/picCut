//
//  hehViewController.h
//  RKCropImageControllerExample
//
//  Created by YuShuHui on 13-10-15.
//  Copyright (c) 2013年 ren6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hehViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate >
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)btn:(id)sender;

@end
