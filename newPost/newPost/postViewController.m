
//
//  postViewController.h
//  newPost
//
//  Created by YuShuHui on 13-9-25.
//  Copyright (c) 2013年 tiboo. All rights reserved.
//

#import "postViewController.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"
#import "ListViewController.h"

#define MAX_PIC_NUM  8
@interface postViewController () {
    int pic_num;
    int post_num;
    NSMutableArray *pic_ids;
    BOOL titleFocus;
    NSString *titleMessageString;
    NSString *contentMessageString;
    BOOL postSuccess;
}
@property UIBarButtonItem * postBtn;
@property UIView *btnView;
@property UITextView *contentTextView;
@property UIScrollView *picView;
@property UIImageView *imgView;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property UIAlertView *baseAlert;
@end
@implementation postViewController
@synthesize selectedPhotos;
@synthesize postBtn;
@synthesize btnView;
@synthesize contentTextView;
@synthesize picView;
@synthesize imagePicker = _imagePicker;
@synthesize baseAlert;
@synthesize imgView;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)doKeMu{
    ListViewController *VieContro = [[ListViewController alloc] init];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"后退";
    
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:VieContro animated:YES];
    VieContro.title = @"选年纪";
}
-(void)viewDidLoad
{
    pic_num = 0;
   // self.title = @"选择科目";
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    centerButton.frame = CGRectMake(130, 7, 80, 30);
    [centerButton setTitle:@"选择科目" forState:UIControlStateNormal];
    
    [centerButton addTarget:self action:@selector(doKeMu) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:centerButton];
    
    [self addPostBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.view.bounds = CGRectMake(0, -20, 320, self.view.frame.size.height);
    }
    
    //btnView
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 40)];
    btnView.backgroundColor = [UIColor grayColor];
    //say button
    UIButton *sayButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    // [self.sayButton setTitle:@"语音" forState:UIControlStateNormal];
    sayButton.frame = CGRectMake(15, 7, 41, 26);
    [sayButton addTarget:self action:@selector(doTalk) forControlEvents:UIControlEventTouchUpInside];
    UIImage *redButtonImage = [UIImage imageNamed:@"say"];
    [sayButton setBackgroundImage:redButtonImage forState:UIControlStateNormal];
    [redButtonImage release];
    [self.btnView addSubview:sayButton];
    
    //picButton
    UIButton *picButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    //[self.picButton setTitle:@"图片" forState:UIControlStateNormal];
    
    picButton.frame = CGRectMake(100, 7, 45, 26);
    [picButton addTarget:self action:@selector(doPic) forControlEvents:UIControlEventTouchUpInside];
    UIImage *picButtonImage = [UIImage imageNamed:@"pic"];
    [picButton setBackgroundImage:picButtonImage forState:UIControlStateNormal];
    [picButtonImage release];
    [self.btnView addSubview:picButton];
    
    //keyboard
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    // [self.keyboardButton setTitle:@"键盘" forState:UIControlStateNormal];
    keyboardButton.frame = CGRectMake(190, 7, 45, 26);
    [keyboardButton addTarget:self action:@selector(doKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UIImage *keyboardButtonImage = [UIImage imageNamed:@"keyboard"];
    [keyboardButton setBackgroundImage:keyboardButtonImage forState:UIControlStateNormal];
    [keyboardButtonImage release];
    [self.btnView addSubview:keyboardButton];
    
    [self.view addSubview:self.btnView];
    //content text view
    
    
    if (pic_num==0) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 85, 280, 250)];
    }else{
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 85, 280, 100)];
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 164, 280, 250)];
    }
    [self.view addSubview:self.imgView];
    self.contentTextView.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:self.contentTextView];
    self.contentTextView.text = @"用清晰的文字描述你的问题，可以更快获得解答";
    
    //observe keyboard events
    
    //keyboard will show
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    //textview change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTextViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTextViewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",@"http://dev.voicecloud.cn:1028/index.htm",@"515a7c4f"];
    
	// init the RecognizeControl
    // 初始化语音识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:CGPointMake(20, 70) initParam:initParam];
    //initWithOrigin   initWithOrigin H_CONTROL_ORIGIN this is a frame ,,,param
	
    [self.view addSubview:_iFlyRecognizeControl];   //need addSubView  self.view
    
    //[_iFlyRecognizeControl bringSubviewToFront:self.contentTextView];
    // Configure the RecognizeControl
    // 设置语音识别控件的参数,具体参数可参看开发文档
	[_iFlyRecognizeControl setEngine:@"sms" engineParam:nil grammarID:nil];
    //setEngine
	[_iFlyRecognizeControl setSampleRate:16000];
    //setSampleRate
	_iFlyRecognizeControl.delegate = self;
    //delegat
    //不显示log
	[_iFlyRecognizeControl setShowLog: NO];
    //setShowLog
    [initParam release];
    
    self.selectedPhotos = [[NSMutableArray alloc] init];
    post_num = 0;   //set the post num
    pic_ids = [[NSMutableArray alloc] init];
    titleFocus = TRUE;
    postSuccess = false;
    [super viewDidLoad];
    
}
//hide keyboard  move up the btnView
- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"fdfdffdf");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    [UIView commitAnimations];
    
}
//hide keyboard  move down the btnView
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    [UIView commitAnimations];
    
}

-(void)contentTextViewChanged:(NSNotification *)notification {
   
    [self enablePostBtn];
}

//textField delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.contentTextView becomeFirstResponder];
    return YES;
}
-(void) titleValueChanged
{
    [self enablePostBtn];
}


//enable  post btn
-(void)enablePostBtn
{
    if( self.contentTextView.text.length){
        [self.postBtn setEnabled:YES];
    } else {
        [self.postBtn setEnabled:NO];
    }
}

//add post btn
-(void) addPostBtn
{
    self.postBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonSystemItemSave target:self action:@selector(doPost)];
    self.navigationItem.rightBarButtonItem = self.postBtn;
    [self.postBtn setEnabled:NO];
}

// show talk view
-(void)doTalk
{
    if([_iFlyRecognizeControl start]) {
        
    }
    [self.view bringSubviewToFront:_iFlyRecognizeControl];
    [self hideKeyboard];
}

//pick pic and take photo
-(void)doPic
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"相机拍摄",@"本地图库", nil];
    myActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [myActionSheet showInView:self.view];
    [myActionSheet release];
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
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
        
    }else {
        // DLog(@"该设备无摄像头");
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
    [picker release];
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        //   UIImage *img = [UIImage imageWithData:data];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        NSString *imageDocPath = [documentPath stringByAppendingString:@"/ImageFile"];
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *str = [[NSString alloc] initWithFormat:@"imageyuhu.png"];
        NSString *imagePath = [imageDocPath stringByAppendingPathComponent:str];
        [str release];
        [selectedPhotos addObject:imagePath];
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
        
        //  [self uploadAvatar];
        
        pic_num++;
        
        [self.contentTextView removeFromSuperview];
        self.contentTextView = nil;
        [self.imgView removeFromSuperview];
        self.imgView = nil;
        if (pic_num==0) {
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 85, 280, 250)];
        }else{
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 85, 280, 100)];
            self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 164, 280, 250)];
        }
        [self.view addSubview:self.imgView];
        [self.view addSubview:self.contentTextView];
        self.contentTextView.text = @"用清晰的文字描述你的问题，可以更快获得解答";
        self.imgView.image =image;
        
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    
}


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



-(void)doKeyboard
{
    
    
    [self.contentTextView resignFirstResponder];
    
    
}

-(void)hideKeyboard
{
    
    [self.contentTextView resignFirstResponder];
    
}

//发帖流程
-(void)doPost
{
    if( self.contentTextView.text.length < 12) {
        baseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容太短了，请再写吧点" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [baseAlert show];
        
        return;
    }
    
    baseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在发布中..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [baseAlert show];
    
    if(self.selectedPhotos.count) {
        ASINetworkQueue *queue = [[ASINetworkQueue alloc] init];
        for(NSString *path in self.selectedPhotos) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.tiboo.cn/tibooextend/appapi/forum.php?ac=uploadimage"]];
            
            [request setTimeOutSeconds:10];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
            [request setShouldContinueWhenAppEntersBackground:YES];
#endif
            [request setDelegate:self];
            [request setDidFailSelector:@selector(uploadFailed:)];
            [request setDidFinishSelector:@selector(imageUploadFinished:)];
            [request setFile:path forKey:@"file"];
            [queue addOperation:request];
            [queue go];
            
        }
        
    } else {
        
        //   NSString* content = [self.contentTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = @"";
        str = @"";
        
        NSURL *url = [NSURL URLWithString:str];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setTimeOutSeconds:10];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        [request setShouldContinueWhenAppEntersBackground:YES];
#endif
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(didFinishSelector:)];
        [request startAsynchronous];
    }
}

- (void) handleTimer: (NSTimer *) timer
{
    [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
    baseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [baseAlert show];
    
}

- (void) handleTimer2: (NSTimer *) timer
{
    NSUserDefaults *thread = [NSUserDefaults standardUserDefaults];
    NSArray *value = [[NSArray alloc] initWithObjects:@"",@"", nil];
    [thread setObject:value forKey:@"thread_info"];
    postSuccess = YES;
    [baseAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)didFinishSelector:(ASIHTTPRequest *)theRequest
{
    NSLog(@"%@",theRequest.responseString);
    
}

-(void)sendArticleFinished:(ASIHTTPRequest *)theRequest
{
    NSLog(@"%@",theRequest.responseString);
}

-(void) uploadFailed
{
    post_num ++;
}

-(void) imageUploadFinished:(ASIHTTPRequest *)theRequest
{
    NSLog(@"%@",theRequest.responseString);
    post_num++;
    [pic_ids addObject:[self getPicAid:theRequest.responseData] ];
    if(post_num >= self.selectedPhotos.count) {
        [self sendArticle];
    }
    
}



-(NSString *)getPicAid:(NSData *)responseData
{
    
    NSError *error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSString *aid = [json objectForKey:@"aid"];
    
    return aid;
}

-(void) sendArticle
{
    NSString *ids = @"";
    if(pic_ids.count) {
        ids = [pic_ids componentsJoinedByString:@","];
    }
    NSString* content = self.contentTextView.text;
    NSString *str = @"http://www.tiboo.cn/tibooextend/appapi/forum.php?ac=post&fid=231";
    NSURL *url = [NSURL URLWithString:str];
    ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setDelegate:self];
    
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:ids forKey:@"flashatt"];
    [request setDidFinishSelector:@selector(uploadFinished:)];
    [request setDidFailSelector:@selector(sendArticleFailed:)];
    [request startAsynchronous];
}

-(void)sendArticleFailed:(ASIHTTPRequest*)request
{
    NSLog(@"%@",request.responseString);
}

-(void)uploadFinished:(ASIHTTPRequest*)request
{
    [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
    NSLog(@"fdfdsfdsf%@",request.responseString);
    NSString *responseString = request.responseString;
    NSRange start = [responseString rangeOfString:@"success"];
    if (start.location != NSNotFound)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发帖成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [av show];
        [av dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发帖失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

//talk
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"识别结束回调finish.....");   //this is callback   is important
    //enable button   self enableButton
	
    // 获取上传流量和下载流量  FALSE:本次识别会话的流量，TRUE所有识别会话的流量
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow:FALSE],[iFlyRecognizeControl getDownflow:FALSE]);
    //ll useage    getUpflow    getDownflow
	
}

- (void)onUpdateTextView:(NSString *)sentence      //sentence      onUpdateTextView  need this method to show text
{
    if(!titleFocus) {
        self.contentTextView.text = [self.contentTextView.text stringByAppendingPathComponent:sentence];
        
    }
    [self.postBtn setEnabled:YES];
}



- (void)onRecognizeResult:(NSArray *)array
{
    //  execute the onUpdateTextView function in main thread
    //  在主线程中执行onUpdateTextView方法  do this ,,,
    //performSelectorOnMainThread   onUpdateTextView  withobject    NAME  waitUntil Done
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	[self onRecognizeResult:resultArray];
    
    // this is callback
	
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    titleFocus = TRUE;
}

- (void)contentTextViewBeginEditing:(UITextView *)textView {
    titleFocus = FALSE;
    
}

-(void)didReceiveMemoryWarning
{
    NSLog(@"fdfdf");
}

@end

