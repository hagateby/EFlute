//
//  ViewController.h
//  test3
//
//  Created by pmoiphone on 14-5-21.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SoundManager.h"
#import "EFluteManager.h"
#import "SettingMasterViewController.h"
#import "DKCircleButton.h"


@interface ViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UIImageView * mainview;
    //int pressnum[6];
    int presscount ;
    NSMutableArray * finderarray;
    
    SoundManager * soundManager ;
    
    MicManager * micManager;
    
    EFluteManager * efluteManager;
    
    CMMotionManager * motionmanger;
    
    NSOperationQueue * operatioQqueue;
    
    __weak IBOutlet UIImageView *manImage;
    
   }



-(NSInteger)presstouch: (NSInteger)num touchtype:(int) touchtype;

-(void)registertouch;
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender;
-(void)handleDoubleFingerEvent:(UITapGestureRecognizer * )sender;

-(void)orientationChanged:(NSNotification *)notification;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end
