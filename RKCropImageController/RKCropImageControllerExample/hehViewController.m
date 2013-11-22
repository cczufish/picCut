//
//  hehViewController.m
//  RKCropImageControllerExample
//
//  Created by YuShuHui on 13-10-15.
//  Copyright (c) 2013年 ren6. All rights reserved.
//

#import "hehViewController.h"
#import "ViewController.h"



@interface hehViewController ()

@end

@implementation hehViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 添加图片事件
- (void)doPic{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"相机拍摄",@"本地图库", nil];
    myActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [myActionSheet showInView:self.view];
    
}

//回调
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self pickPhoto];
            break;
    }
}

//  从相机加载
-(void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //   picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];

    }else {
        NSLog(@"该设备无摄像头");
    }
    
    
}


//  从相册加载
-(void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
     picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
    //[self cropTapped];
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    self.imgView.image = image;
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    ViewController *cropController = [[ViewController alloc] init];
    cropController.imageView1.image = image;
    
    [self presentModalViewController:cropController animated:YES];

    
}

- (IBAction)btn:(id)sender {
    
    [self doPic];
}
@end
