//
//  postViewController.h
//  newPost
//
//  Created by YuShuHui on 13-9-25.
//  Copyright (c) 2013年 tiboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizeControl.h"

@interface postViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,NSFileManagerDelegate,UITextViewDelegate,IFlyRecognizeControlDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    IFlyRecognizeControl		*_iFlyRecognizeControl;
    NSMutableArray *selectedPhotos;
}
@property (nonatomic, strong)NSMutableArray *selectedPhotos;
@end
