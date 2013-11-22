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

@interface ImageFilterProcessViewController ()<RKCropImageViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *drawView;

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
    [self.imageView addGestureRecognizer:tap];
    //[tap release];
}
- (IBAction)fitlerDone:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        [delegate imageFitlerProcessDone:self.imageView.image];
    }];
}


-(void) initBarView {
    
    //导航栏背景图片
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,44+NAVIGATIONHEIGHT)];
    backImage.backgroundColor = [z_UI colorWithHexString:@"#2786CB"];
    [self.view addSubview:backImage];
    [backImage release];
    
    UIButton *backToParentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backToParentBtn.frame = CGRectMake(5, 0+NAVIGATIONHEIGHT, 60, 44);
    [backToParentBtn setImage:[UIImage imageNamed:@"nav_return.png"] forState:UIControlStateNormal];
    [backToParentBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToParentBtn];
    
    //设置可见
    backToParentBtn.hidden = NO;
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(250, 7+NAVIGATIONHEIGHT, 60, 34)];
    [rightBtn addTarget:self action:@selector(fitlerDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UIButton *centerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerBtn setFrame:CGRectMake(80, 7+NAVIGATIONHEIGHT, 60, 34)];
    [centerBtn addTarget:self action:@selector(caijian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropTapped)];
    [centerBtn addGestureRecognizer:tap];
    [tap release];
    
    
    UIButton *ceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [ceBtn setTitle:@"旋转" forState:UIControlStateNormal];
    [ceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ceBtn setFrame:CGRectMake(150, 7+NAVIGATIONHEIGHT, 60, 34)];
    [ceBtn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ceBtn];
}

- (void)xuanzhuan{
    self.imageView.transform=CGAffineTransformMakeRotation(90);   //传入弧度值
}

-(void) startAnimation
{
    
     [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(transformAction) userInfo: nil repeats: NO];
    
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.01];
//    [UIView setAnimationDelegate:self];
//    self.imageView.transform = CGAffineTransformMakeRotation(45 * (M_PI / 90.0f));
//    [UIView commitAnimations];
//    self.imageView.image = self.imageView.image;
}

-(void)transformAction {
    angle = angle + M_PI / 2;//angle角度 double angle;
    if (angle >= 2 * M_PI) {//大于 M_PI*2(360度) 角度再次从0开始
        angle = 0;
    }
//    static  int n = 1;
//    CGAffineTransform transform=CGAffineTransformMakeRotation(angle);
//    self.imageView.transform = transform;
    
    
    UIImage *_image =[self.imageView image];
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,_image.size.width, _image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(angle);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, angle);
    //    CGContextRotateCTM(bitmap, DegreesToRadians(90));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-_image.size.width / 2, -_image.size.height / 2, _image.size.width, _image.size.height), [_image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 5.0f;
    
    self.imageView.image = currentImage;
    
    
    CGPoint center = self.scrollView.center;
    CGFloat heightWillBe;
    CGFloat widthWillBe;
    CGSize size;
    CGFloat widthKoef = self.scrollView.frame.size.width/self.imageView.image.size.width;
    CGFloat heightKoef = self.scrollView.frame.size.height/self.imageView.image.size.height;
    if ( widthKoef < heightKoef){
        // width is bigger than height
        heightWillBe  = self.imageView.image.size.height * self.imageView.frame.size.width/self.imageView.image.size.width;
        size = CGSizeMake(self.imageView.frame.size.width, heightWillBe);
    } else {
        // height is bigger than width
        widthWillBe  = self.imageView.image.size.width * self.imageView.frame.size.height/self.imageView.image.size.height;
        size = CGSizeMake(widthWillBe, self.imageView.frame.size.height);
    }
    [self.scrollView setBounds:CGRectMake(0, 0, size.width, size.height)];
    [self.imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.scrollView setCenter:center];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.alwaysBounceVertical = NO;
    
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.scrollView.scrollEnabled)
        return self.drawView;
    else return nil;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale {
    [aScrollView setZoomScale:scale+0.01 animated:NO];
    [aScrollView setZoomScale:scale animated:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        self.scrollView.scrollEnabled = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(allowScrollingAndZooming) object:nil];
        [self performSelector:@selector(allowScrollingAndZooming) withObject:nil afterDelay:0.2];
    }
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) allowScrollingAndZooming{
    self.scrollView.scrollEnabled = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
   
    [currentImage release],currentImage  =nil;
    
}


-(void) cropTapped{
    RKCropImageController *cropController = [[RKCropImageController alloc] initWithImage:self.imageView.image];
    cropController.delegate = self;
    [self presentModalViewController:cropController animated:YES];
}
-(void)cropImageViewControllerDidFinished:(UIImage *)image{
    self.imageView.image = image;
    
    CGPoint center = self.scrollView.center;
    CGFloat heightWillBe;
    CGFloat widthWillBe;
    CGSize size;
    CGFloat widthKoef = self.scrollView.frame.size.width/self.imageView.image.size.width;
    CGFloat heightKoef = self.scrollView.frame.size.height/self.imageView.image.size.height;
    if ( widthKoef < heightKoef){
        // width is bigger than height
        heightWillBe  = self.imageView.image.size.height * self.imageView.frame.size.width/self.imageView.image.size.width;
        size = CGSizeMake(self.imageView.frame.size.width, heightWillBe);
    } else {
        // height is bigger than width
        widthWillBe  = self.imageView.image.size.width * self.imageView.frame.size.height/self.imageView.image.size.height;
        size = CGSizeMake(widthWillBe, self.imageView.frame.size.height);
    }
    [self.scrollView setBounds:CGRectMake(0, 0, size.width, size.height)];
    [self.imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.scrollView setCenter:center];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.alwaysBounceVertical = NO;
}


@end
