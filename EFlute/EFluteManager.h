//
//  EFluteManager.h
//  EFlute
//
//  Created by liuwh on 14-6-25.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MicManager.h"
#import "SoundManager.h"
//#import "ViewController.h"

@interface EFluteManager : NSObject

{
    NSArray *basetoneArrary;

    NSMutableArray * currenttoneArrary;
    //指法设置音与界面对照映射
    NSMutableDictionary * finderSettingDictionary;
    
    //音效
    //
    NSNumber* direct_H ;
    NSNumber* direct_M ;
    NSNumber* direct_L ;
    
    SoundManager* sm ;
    MicManager*   mm ;

}

//是否在播放
@property  BOOL isPlay;
//是否有在吹气
@property  BOOL isBlow;

//方向
@property  int directFlute ;

//麦克风检测阀值
@property  double blowThresholdValue;

//吹气的位置 0左侧 1右侧
@property  int blowPiont;

//调式
@property int tonelvl;


+(EFluteManager *)sharedInstance;

-(id)init;

-(void)defaultFinderSetting;

-(void)defaultToneLvl;

-(void)checkUserData;

-(void)getUserData;

-(void)setUserData;

-(NSString *)checkCurrentFinder;

-(void)eventFinder:(NSNotification *) noti;

-(void)eventMic:(NSNotification *) noti;

-(void)play;

-(void)stop;

@end
