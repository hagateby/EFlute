//
//  MicManager.m
//  test3
//
//  Created by pmoiphone on 14-6-10.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//


#import "MicManager.h"

@implementation MicManager
NSString * const NTEFLUTECORDVOLUMECHANGE=@"NTEFLUTECORDVOLUMECHANGE";


/*初始化设备*/
-(void)initReord
{
    
    NSError * error;
    AVAudioSession *audiosession;
    
    recordEncoding= ENC_ACC;
    
    //第一次调用这个方法的时候，系统会提示用户让他同意你的app获取麦克风的数据
    // 其他时候调用方法的时候，则不会提醒用户
    // 而会传递之前的值来要求用户同意
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 用户同意获取数据
        } else {
            // 可以显示一个提示框告诉用户这个app没有得到允许？
        }
    }];
    
    
    
    if 	([[[UIDevice currentDevice] systemVersion] compare:@"7.0"]!= NSOrderedAscending) {
        //7.0 第一次运行会提示，是否允许使用麦克风
        audiosession = [AVAudioSession sharedInstance];
        // [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        
        [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [audiosession setActive:YES error:nil];
        /*
        if (audiosession) {
            NSLog(@"err creating session %@" ,[error debugDescription]);
            return;
        }else {
            [audiosession setActive:YES error:nil];
        }
        */
    }
    
    NSMutableDictionary * recordSettings =[[NSMutableDictionary alloc] initWithCapacity:10];
    
    
    if(recordEncoding == ENC_PCM)
    {
        
        
        [recordSettings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        
    }else
    {
        NSNumber * formatObect;
        switch (recordEncoding) {
            case (ENC_ACC):
                formatObect =[NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObect =[NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
                
            case (ENC_IMA4):
                formatObect =[NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObect =[NSNumber numberWithInt: kAudioFormatiLBC];
                break;
                
            case (ENC_ULAW):
                formatObect =[NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObect =[NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
        }
        
        [recordSettings setObject:formatObect forKey:AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];//采样库
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];  //通道数目：0单声道 1立体声
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];// 解码率
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位
        [recordSettings setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];//
        
        
    }
   
 
    
    
    NSURL *url =[NSURL fileURLWithPath:@"/dev/null"];
    
    recorder =[[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if (recorder) {
        [recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
		levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
    }else
        NSLog([error description]);
    
    //监听事件
    
    /*
     AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,
     [[NSNotificationCenter defaultCenter] addObserver:self selector:kAudioSessionProperty_AudioRouteChange name:audioRouteChangeListenerCallback  object:nil];
     
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged)  name:@"AVSystemController_SystmeVolumeDidChangeNotification"  object:nil];
     */
    [self initSCListener];
    [self printCurrentCategory];
}

-(void)initSCListener
{
    sclistener =[SCListener sharedListener];
    
    [sclistener listen];
    
    [sclistener averagePower];
    
    [sclistener peakPower];
    
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    //声音太小，以下代码可以解决问题：
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    

}

/*
 -(void)volumeChanged:(NSNotification *) notif
 {
 
 float volume=[[notification userinfo] objectForKey:@"AVSystmeController_AudioVolumeNotificationParameter"];
 DDLogVerbos(@"current volume = %f" ,volume);
 
 NSLog(@"AVSystemController_SystmeVolumeDidChangeNotification");
 
 }
 */
-(double) getPower
{
    double  power =0.0;
    // AudioQueueLevelMeterState *levels=[sclistener levels];
    //Float32 peak = levels[0].mPeakPower;
    //Float32 average =levels[0].mAveragePower;
    
    // Make this a global variable, or a member of your class:
    
    double micPower = 0.0;
    
    // Tweak this value to your liking (must be between 0 and 1)
    
    const double ALPHA = 0.05;
    
    
    // Do this every 'tick' of your application (e.g. every 1/30 of a second)
    
    double instantaneousPower = [[SCListener sharedListener] peakPower];
   // NSLog(@"instantaneousPower =%f" ,instantaneousPower);
    
    
    // This is the key line in computing the low-pass filtered value
    
    micPower = ALPHA * instantaneousPower + (1.0 - ALPHA) * micPower;
    
    double THRESHOLD =0.99;
    
    // NSLog(@"micPower =%f" ,micPower);
    
    //if(micPower > THRESHOLD)  // 0.99, in your example
    
    power =micPower;
    
    return power;
    
}

/*分时检查回调函数*/
- (void)levelTimerCallback:(NSTimer *)timer {
    
        _lowPassResults =[self getPower];
        [self notificationEFluteRecordVolue: [NSNumber  numberWithDouble:_lowPassResults]];
}

-(double) getLowPass
{
    recorder.meteringEnabled =YES;
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
    
    
    
	//double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    // double averagePowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
    Float32 peakPowerForChannel = [recorder peakPowerForChannel:0];
    
    NSLog(@"peakPowerForChannel: %f",peakPowerForChannel);
    
    //NSLog(@" averagePowerForChannel: %f ",averagePowerForChannel);
    
	_lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * _lowPassResults;
    
    if (_lowPassResults < 0.25)
    {
        return _lowPassResults;
    }else
    {
         return _lowPassResults;
    }
    

}

-(void)notificationEFluteRecordVolue :(NSNumber *)volume
{
    
   // NSLog(@" NTEFLUTECORDVOLUMECHANGE =%f", [volume doubleValue]);
    
    NSNotificationCenter *nc= [NSNotificationCenter defaultCenter];

    [nc postNotificationName:NTEFLUTECORDVOLUMECHANGE object:volume];
}

//检测声音输入设备
-(BOOL)hasMicphone{
    return [[AVAudioSession sharedInstance] inputIsAvailable];
}
//检测声音输出设备
//对于输出设备的检测，我们只考虑了2个情况，一种是设备自身的外放（iTouch/iPad/iPhone都有），一种是当前是否插入了带外放的耳机。iOS已经提供了相关方法用于获取当前的所有声音设备，我们只需要检查在这些设备中是否存在我们所关注的那几个就可以了。获取当前所有声音设备
- (BOOL) hasHeadset{
    
#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode :audio session code works only on a device
    return NO;
#else
    
    UInt32 routeSize = sizeof (CFStringRef);
    
    CFStringRef route;
    /*
     OSStatus error = AudioessionGetroperty (kAudioSessionProperty_AudioRoute,&routeSize,&route);
     
     if (!error &&  (route !=NULL)){
     
     NSString *routeStr = (__bridge NSString*)route;
     NSLog(@"Audioroute %a",routeStr);
     
     NSRange headphoneRange = [routeStr rangeOfString:@"Headphone"];
     NSRange headsetRange=[routeStr rangeOfString:@"Headset"];
     
     if (headphoneRange.location == NSNotFound){
     return YES;
     }else if (headsetRange.location !=NSNotFound)
     {
     return NO;
     }
     
     }
     */
    return YES;
#endif
    
}

//设置声音输出设备
//在我们的项目中，存在当正在播放时用户会插入或拔出耳机的情况。如果是播放时用户插入了耳机，苹果会自动将声音输出指向到耳机并自动将音量调整为合适大小；如果是在用耳机的播放过程中用户拔出了耳机，声音会自动从设备自身的外放里面播出，但是其音量并不会自动调大。经过我们的测试，我们发现当播放时拔出耳机会有两个问题（也许对你来说不是问题，但是会影响我们的app）：音乐播放自动停止声音音量大小不会自动变大，系统仍然以较小的声音（在耳机上合适的声音）来进行外放对于第一个问题，实际上就是需要能够检测到耳机拔出的事件；而第二个问题则是需要当耳机拔出时强制设置系统输出设备修改为系统外放。强制修改系统声音输出设备：

-(void) resetOutputTarget{
    BOOL isHeadset =[self hasHeadset];
    NSLog(@"will set output target is_headset =%@",isHeadset ? @"YES" :@"NO");
    UInt32 audioRouteOverride =isHeadset? kAudioSessionOverrideAudioRoute_None :kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride),&audioRouteOverride );
}


//设置Audio工作模式
//（category，我当做工作模式理解的）iOS系统中Audio支持多种工作模式（category），要实现某个功能，必须首先将AudioSession设置到支持该功能的工作模式下。所有支持的工作模式如下
-(BOOL)checkAndPrepareCategoryForRecording{
    recoding =YES;
    BOOL hasMicphone = [self hasMicphone];
    NSLog(@" will set category for recording hasmicophone =%@" ,hasMicphone ? @"YES" :@"NO");
    if (hasMicphone) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    [self resetOutputTarget];
    return hasMicphone;
}


-(void) audioRouteChangeListenerCallback:
(void   *) inUserData
                            inPropertyId:(AudioSessionPropertyID) inPropertyID
                       inProperValueSize:( UInt32 )  inProperValueSize
                        inPeropertyValue:( void            *)inPropertyValue
{
    if(inPropertyID != kAudioSessionProperty_AudioRouteChange)
        return;
    //determines the reason for the route change to ensure that it is not because of a category change .
    
    CFDictionaryRef routeChangeDictionary = inPropertyValue;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason)) ;
    SInt32 routeChangeReason;
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    NSLog(@"======================= routechangereason ;%d", (int)routeChangeReason);
    MicManager * _self =(__bridge MicManager *) inUserData;
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable){
        [_self resetSetting];
        if(![_self hasHeadset]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ununpluggingHeads" object :nil];
        }
    }else if (routeChangeReason ==kAudioSessionRouteChangeReason_NewDeviceAvailable){
        [_self resetSetting];
        if(![_self hasHeadset]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pluggIngMicrophe" object :nil];
        }
    }else if (routeChangeReason ==kAudioSessionRouteChangeReason_NoSuitableRouteForCategory){
        [_self resetSetting];
        if(![_self hasHeadset])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lostMicorPhone" object :nil];
        }
    }
    [_self printCurrentCategory];
}


/*重新设置类别*/
-(void) resetCategory{
    if (!recoding) {
        NSLog(@"will set category to static value = avaudiosessioncategoryplayback!");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

/*重新设置*/
-(void) resetSetting{
    [self resetOutputTarget];
    [self resetCategory];
    
}


-(void)cleanUpForEndRecording{
    recoding =NO;
    [self resetSetting];
    BOOL isSucced=[[AVAudioSession sharedInstance] setActive :YES error :NULL];
    if(!isSucced)
    {
        NSLog(@"reset audio session stttings failed!");
    }
}

-(void)printCurrentCategory{
    UInt32 audioCategory;
    UInt32 size =sizeof(audioCategory);
    /*
     AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &size, audioCategory);
     
     if (audioCategory==kAudioSessionCategory_UserInterfaceSoundEffects) {
     
     NSLog(@"current category is :audioessioncategory_userinterfacesoundeffects");
     
     }else if (audioCategory == kAudioSessionCategory_AmbientSound)
     {
     NSLog(@"current category is :kAudioSessionCategory_AmbientSound");
     
     }else if (audioCategory ==kAudioSessionCategory_SoloAmbientSound){
     
     NSLog(@"current category is :kAudioSessionCategory_SoloAmbientSound");
     
     }else if (audioCategory ==kAudioSessionCategory_MediaPlayback){
     
     NSLog(@"current category is :kAudioSessionCategory_MediaPlayback");
     
     }else if (audioCategory ==kAudioSessionCategory_LiveAudio){
     
     NSLog(@"current category is :kAudioSessionCategory_LiveAudio");
     
     }else if (audioCategory ==kAudioSessionCategory_RecordAudio){
     
     NSLog(@"current category is :kAudioSessionCategory_RecordAudio");
     
     }else if (audioCategory ==kAudioSessionCategory_PlayAndRecord){
     
     NSLog(@"current category is :kAudioSessionCategory_PlayAndRecord");
     
     }else if (audioCategory ==kAudioSessionCategory_AudioProcessing){
     
     NSLog(@"current category is :kAudioSessionCategory_AudioProcessing");
     
     }else {
     NSLog(@"current category is :UNKNOW");
     }
     */
}


@end
