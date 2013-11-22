//
//  ImageFilterProcessViewController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "ImageFilterProcessViewController.h"
#import "IphoneScreen.h"
#import "RKCropImageController.h"

@interface ImageFilterProcessViewController ()<RKCropImageViewDelegate>

@end

@implementation ImageFilterProcessViewController
@synthesize currentImage = currentImage, delegate = delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)caijian{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropTapped)];
    [rootImageView addGestureRecognizer:tap];
    //[tap release];
}
- (IBAction)fitlerDone:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        [delegate imageFitlerProcessDone:rootImageView.image];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(10, 20, 34, 34)];
    [leftBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];

    [rightBtn setFrame:CGRectMake(230, 20, 60, 34)];
    [rightBtn addTarget:self action:@selector(fitlerDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UIButton *centerBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [centerBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    
    [centerBtn setFrame:CGRectMake(150, 20, 60, 34)];
    [centerBtn addTarget:self action:@selector(caijian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
    
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.388 alpha:1.000]];
    rootImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(40, 70, 230, 300)];
    rootImageView.image = currentImage;
    rootImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropTapped)];
    [centerBtn addGestureRecognizer:tap];
    [tap release];
    
    [self.view addSubview:rootImageView];
    
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    rootImageView = nil;
    [currentImage release],currentImage  =nil;
    
}


-(void) cropTapped{
    RKCropImageController *cropController = [[RKCropImageController alloc] initWithImage:rootImageView.image];
    cropController.delegate = self;
    [self presentModalViewController:cropController animated:YES];
}
-(void)cropImageViewControllerDidFinished:(UIImage *)image{
    rootImageView.image = image;
}


@end
