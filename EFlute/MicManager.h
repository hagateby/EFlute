//
//  MicManager.h
//  test3
//
//  Created by pmoiphone on 14-6-10.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "SCListener.h"


@interface MicManager : NSObject
{
    
    AVAudioRecorder * recorder;
    AVAudioPlayer * audioPlayer;
    BOOL recoding ;
    
    NSTimer *levelTimer;
	SCListener * sclistener;
    int recordEncoding;
   // float recordVolume ;
    
    enum{
        ENC_ACC=1,
        ENC_ALAC=2,
        ENC_IMA4=3,
        ENC_ILBC=4,
        ENC_ULAW=5,
        ENC_PCM=6,
    }encodingTypes;
    
    
   
    
}
@property double lowPassResults;

/*初始化设备*/
-(void)initReord;

/*设置时间回调*/
- (void)levelTimerCallback:(NSTimer *)timer;

//检测声音输入设备
-(BOOL)hasMicphone;



-(void)notificationEFluteRecordVolue :(NSNumber *) volume;

//检查是否有耳机插入
- (BOOL) hasHeadset;

//设置声音输出设备
-(void) resetOutputTarget;

//设置Audio工作模式
-(BOOL)checkAndPrepareCategoryForRecording;

/*重新设置类别*/
-(void) resetCategory;

/*重新设置*/
-(void) resetSetting;

-(void)cleanUpForEndRecording;

-(void)printCurrentCategory;

-(void) audioRouteChangeListenerCallback:
(void   *) inUserData
                            inPropertyId:(AudioSessionPropertyID) inPropertyID
                       inProperValueSize:( UInt32 )  inProperValueSize
                        inPeropertyValue:( void            *)inPropertyValue;

@end
