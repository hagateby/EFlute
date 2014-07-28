//
//  ViewController.m
//  test3
//
//  Created by pmoiphone on 14-5-21.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController


NSString * const NTEFLUTEFINDERCHANGE=@"NTEFLUTEFINDERCHANGE";

bool const isIphoe = YES;


int TONE_LVL[] = {1,2,3,4,5,6,7,8,9,10,11,12};

DKCircleButton *button1;
DKCircleButton *button2;
DKCircleButton *button3;
DKCircleButton *button4;
DKCircleButton *button5;
DKCircleButton *button6;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //UIImage * mainImage =[UIImage imageNamed:@"main.png"];
    //UIColor * backgroud =[[UIColor alloc] initWithPatternImage:mainImage] ;
    //self.view.backgroundColor=backgroud;
    //UIImageView * imgview=[[UIImageView alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    //mainview=[[UIImageView alloc ] initWithImage:mainImage];
    //imgview image=mainImage;
    //imgview.frame =CGRectMake(0,0 , 64,96 );
    
    //[self registertouch];
    
    [self.view setMultipleTouchEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
    
    
    [self initDirect];
    
  
    
    [self.view addSubview:mainview];
    
    finderarray =[[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"1", nil];
    
    //soundManager= [[SoundManager alloc] init];
    
    soundManager= [SoundManager alloc];
    efluteManager =[[EFluteManager alloc] init];
    
    
    micManager =[[MicManager alloc] init];
    [micManager initReord];
    
    
    [self initButtonSet];
    //[soundManager test];ß
    
    
}
-(void)initDirect
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)initButtonSet
{
    button1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button1 tag:1 left:260 height:100];
    
    button2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button2 tag:2 left:260 height:220];
    
    button3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button3 tag:3 left:260 height:340];
    
    button4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button4 tag:4 left:80 height:100];
    
    button5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button5 tag:5 left:80 height:220];
    
    button6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self initButtonOne:button6 tag:6 left:80 height:340];
    
    [button6 setHidden:YES];

}
-(void)initButtonOne:(DKCircleButton * )button tag:(NSInteger ) tag left:(int) left height:(int ) height
{
   
    
    button.center = CGPointMake(left, height);
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    button.tag =tag;
    
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [button setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
     
    [button addTarget:self action:@selector(tapUpInsideButton:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(tapDownButton:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:button];

}
- (void)tapUpInsideButton:(UIControl *)c withEvent :ev{
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    DKCircleButton * button =(DKCircleButton*) c;
    button.ishighlight=NO;
   [self presstouch:button.tag touchtype:0];
   // NSLog(@"button1 UIControlEventTouchUpInside  tag=%d" ,button.tag);
    
}

- (void)tapDownButton:(UIControl *)c withEvent :ev {
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];g,u,i
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
   // [button1 setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    DKCircleButton * button =(DKCircleButton*) c;
    button.ishighlight=YES;
   [self presstouch:button.tag touchtype:1];
    //NSLog(@"button1 UIControlEventTouchDown");
}

-(NSInteger)presstouch: (NSInteger)num   touchtype:(int) touchtype {
  
    
   // [self changeShowEvent:imgNum ShowType:!touchtype];
    
    [self getCurrentFinderArray];
    
    NSLog(@"finder =%@",[finderarray componentsJoinedByString:@""]);
    
    [self notificationEFluteFinderChange:finderarray];

    return num;
}



-(void)iniMontion
{
    motionmanger =[[CMMotionManager alloc]init];
    
    [motionmanger startAccelerometerUpdates];
    
    operatioQqueue=[[NSOperationQueue alloc]init];
    
    if(motionmanger.accelerometerAvailable)
    {
        motionmanger.accelerometerUpdateInterval=1.0/10.0;
        [motionmanger startAccelerometerUpdatesToQueue:operatioQqueue
                                           withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                               NSString *labeltext;
                                               if (error) {
                                                   [motionmanger stopAccelerometerUpdates];
                                                   labeltext =[NSString stringWithFormat:@"Accelerometer encountered error :%@ ",error];
                                               }else {
                                                   NSLog(@"accelerometer.x =%f " ,accelerometerData.acceleration.x);
                                                   NSLog(@"accelerometer.y =%f " ,accelerometerData.acceleration.y);
                                                   NSLog(@"accelerometer.z =%f " ,accelerometerData.acceleration.z);
                                                   
                                               }
                                               
                                           }];
    }
    
}

-(void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation =[UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationFaceUp:
            //NSLog(@"屏幕朝上平躺");
            efluteManager.directFlute=0;
            break;
        case UIDeviceOrientationFaceDown:
            //NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            //NSLog(@"未知");
            break;
        case UIDeviceOrientationLandscapeLeft:
            //NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationLandscapeRight:
            //NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationPortrait:
            //NSLog(@"屏幕直立");
            efluteManager.directFlute=1;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //NSLog(@"屏幕直立上下颠倒");
            efluteManager.directFlute=-1;
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   // [self presstouch:touches withEvent:event touchtype:1];
    NSLog(@"touchesbegan");
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   // [self presstouch:touches withEvent:event touchtype:0];
    NSLog(@"touchesEnded");
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"touchmoved");
}
-(void)printPressRect:(CGPoint )curPoint
{
    NSLog(@"touchpoint x= %f y =%f",curPoint.x,curPoint.y);
    // CGRect mainbounds =[[UIScreen mainScreen]bounds];
    // CGRect appframe =[[UIScreen mainScreen] applicationFrame];
    // CGRect mainimgframe =manImage.frame;
    // CGRect presssimgframe =imgPress1.frame;
    
    NSLog(@"mainscreen x=%f y=%f",[[UIScreen mainScreen]bounds].origin.x,[[UIScreen mainScreen]bounds].origin.y);
    NSLog(@"mainscreen x=%f y=%f",[[UIScreen mainScreen] applicationFrame].origin.x,[[UIScreen mainScreen] applicationFrame].origin.y);
    NSLog(@"manimage x= %f y =%f",manImage.frame.origin.x,manImage.frame.origin.y);
    
}


-(void) getCurrentFinderArray
{
    
    if (button1.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:0 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:0 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
    
    if (button2.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:1 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:1 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
    if (button3.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:2 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:2 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
    if (button4.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:3 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:3 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
    if (button5.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:4 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:4 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
    
    
    if (button6.ishighlight==YES) {
        [finderarray replaceObjectAtIndex:5 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    }else
    {
        [finderarray replaceObjectAtIndex:5 withObject:[[NSString alloc] initWithFormat:@"%d" ,0]];
    }
     [finderarray replaceObjectAtIndex:5 withObject:[[NSString alloc] initWithFormat:@"%d" ,1]];
    
}

-(void)notificationEFluteFinderChange :(NSArray *) array
{
    NSNotificationCenter *nc= [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:NTEFLUTEFINDERCHANGE object:array];
    
    //NSLog(@" NTEFLUTEFINDERCHANGE =%@", array);
    
}


-(void)registertouch
{
    //单指单击
    UITapGestureRecognizer * singleFingerOne=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:) ];
    singleFingerOne.numberOfTouchesRequired=1;//手指数
    singleFingerOne.numberOfTapsRequired=1;//tap次数
    singleFingerOne.delegate=self;
    
    //单指双击
    UITapGestureRecognizer * singleFingerTwo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:) ];
    singleFingerTwo.numberOfTouchesRequired=1;//手指数
    singleFingerTwo.numberOfTapsRequired=2;//tap次数
    singleFingerTwo.delegate=self;
    
    //双指单击
    UITapGestureRecognizer * doubleFingerOne=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:) ];
    doubleFingerOne.numberOfTouchesRequired=2;//手指数
    doubleFingerOne.numberOfTapsRequired=1;//tap次数
    doubleFingerOne.delegate=self;
    
    UITapGestureRecognizer * doubleFingerTwo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:)
                                              ];
    doubleFingerTwo.numberOfTouchesRequired=2;
    doubleFingerTwo.numberOfTapsRequired=2;
    doubleFingerTwo.delegate=self;
    //
    [singleFingerOne requireGestureRecognizerToFail:singleFingerTwo];
    
    //
    [doubleFingerOne requireGestureRecognizerToFail:doubleFingerTwo];
    
    [self.view addGestureRecognizer:singleFingerOne];
    [self.view addGestureRecognizer:singleFingerTwo];
    [self.view addGestureRecognizer:doubleFingerOne];
    [self.view addGestureRecognizer:doubleFingerTwo];
    
    
    
}
-(void) handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    //单指单击
    if(sender.numberOfTapsRequired==1){
        
        NSLog(@"单指单击");
    }else if (sender.numberOfTapsRequired==2)
    {
        //双指单击
        NSLog(@"双指单击");
    }
    
}
-(void)handleDoubleFingerEvent:(UITapGestureRecognizer *)sender
{
    //单指双击
    if(sender.numberOfTapsRequired==1){
        
        NSLog(@"单指双击");
    }else if (sender.numberOfTapsRequired==2)
    {
        //双指双击
        NSLog(@"双指双击");
    }}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingClick:(id)sender {
    /*
     SettingMasterViewController * smv = [[SettingMasterViewController alloc] initWithNibName:@"SettingMasterViewControlle" bundle:[NSBundle mainBundle]];
     
     [self setModalTransitionStyle: UIModalTransitionStyleCoverVertical];
     [self presentViewController:smv animated:YES completion:nil];
     */
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingMaster"] animated:YES completion:nil];
    
    
    
    
}


@end
