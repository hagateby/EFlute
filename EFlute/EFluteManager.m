//
//  EFluteManager.m
//  EFlute
//
//  Created by liuwh on 14-6-25.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//


#import "EFluteManager.h"



extern NSString  * NTEFLUTEFINDERCHANGE;

extern NSString *  NTEFLUTECORDVOLUMECHANGE;


static EFluteManager * signObj;

static NSString  const * NTEFLUTEDIRECTCHANGE=@"NTEFLUTEDIRECTCHANGE";

@implementation EFluteManager



+(EFluteManager *)sharedInstance
{
    @synchronized (self)
    {
        if (signObj == nil)
            signObj = [[self alloc] init];
    }
    return signObj;
}


-(id)init
{
    
    @synchronized(self)
    {
        self= [super init];
        
        _isPlay=NO;
        _isBlow=NO; //lwh
        _blowPiont=1;
        _directFlute =0;
        _blowThresholdValue=0.03;
        
        direct_H =[[NSNumber alloc]initWithInt:1];
        direct_M =[[NSNumber alloc]initWithInt:0];
        direct_L =[[NSNumber alloc]initWithInt:-1];
        
        
        
        
        currenttoneArrary=[[NSMutableArray alloc] init];
        
        basetoneArrary=[[NSArray alloc] initWithObjects:@"C3", @"D3" ,@"E3",@"F3",@"G3",@"A3",@"B3",@"C4",@"D4",@"E4",@"F4",@"G4",@"A4",@"B4",@"C5",@"D5",@"E5",@"F5",@"G5",@"A5",@"B5",
                        nil];
        
        finderSettingDictionary =[[NSMutableDictionary alloc] init];
        
        [self checkUserData];
        
        
        
        NSNotificationCenter *nc= [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(eventMic:) name:NTEFLUTECORDVOLUMECHANGE object:nil];
        
        
        [nc addObserver:self selector:@selector(eventFinder:) name:NTEFLUTEFINDERCHANGE object:nil];
        
        sm =[[SoundManager alloc]init] ;
        mm =[[MicManager  alloc] init];
    }
    return self;
    
}

-(void)checkUserData
{
    [self getUserData ];
    
    if(_tonelvl==0)
    {
        
        [self defaultToneLvl];
        
    }
    if (finderSettingDictionary==nil) {
        
        finderSettingDictionary =[NSMutableDictionary dictionary];
        [self defaultFinderSetting];
    }
}


-(void)defaultToneLvl
{
    _tonelvl=1;
}
-(void)defaultFinderSetting
{
    NSMutableArray * finderArray;
    NSLog(@"_directFlute =%d",_directFlute);
    
    NSNumber * directdef =[[NSNumber alloc]initWithInt:1];
    
    if (YES) {
        directdef =[NSNumber numberWithInt:-1];
        //
        finderArray =[NSMutableArray arrayWithObjects: directdef, @"1", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"G2"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"A2"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"B2"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"C3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"0",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"D3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"0",@"0",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"E3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"1",  @"0",@"0",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"F3"];
    }
    if (YES) {
        directdef =[NSNumber numberWithInt:0];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"1", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"G3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"A3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"B3"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"C4"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"0",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"D4"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"0",@"0",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"E4"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"1",  @"0",@"0",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"F4"];
        
    }
    if (NO) {
        directdef =[NSNumber numberWithInt:1];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"1", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"G6"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"1" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"A6"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"1",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"B6"];
        //
        finderArray =[NSMutableArray arrayWithObjects:directdef,@"0", @"0" ,@"0",  @"1",@"1",@"1", nil];
        
        [finderSettingDictionary setObject:finderArray  forKey:@"C5"];
        /*
         //
         finderArray =[NSMutableArray arrayWithObjects:@"0", @"0" ,@"0",  @"0",@"1",@"1", nil];
         
         [finderSettingDictionary setObject:finderArray  forKey:@"D5"];
         //
         finderArray =[NSMutableArray arrayWithObjects:@"0", @"0" ,@"0",  @"0",@"0",@"1", nil];
         
         [finderSettingDictionary setObject:finderArray  forKey:@"E5"];
         //
         finderArray =[NSMutableArray arrayWithObjects:@"0", @"0" ,@"0",  @"0",@"0",@"1", nil];
         
         [finderSettingDictionary setObject:finderArray  forKey:@"F5"];
         */
    }
    
    
}

-(void) setUserData
{
    NSUserDefaults * userdefaults =[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:_tonelvl forKey:@"UDToneLvl"];
    [userdefaults setObject:finderSettingDictionary forKey:@"UDFinderSetting"];
    return;
}

-(void)getUserData
{
    NSUserDefaults * userdefaults =[NSUserDefaults standardUserDefaults];
    _tonelvl=[userdefaults boolForKey:@"UDToneLvl"];
    finderSettingDictionary=[userdefaults objectForKey:@"UDFinderSetting"];
    return;
}
-(void)eventMic:(NSNotification *) noti
{
    NSNumber * blowValue= [noti object];
    //NSLog(@"EVENT NTEFLUTRECORDVOLUMECHANGE =%f", [blowValue doubleValue]);
    if ([blowValue doubleValue] < _blowThresholdValue) {
        _isBlow=NO;
        [self stop];
        
    }else
    {
        _isBlow=YES;
        if (_isPlay ==FALSE) {
            [self play ];
            
        }
    }
}
-(void)eventFinder:(NSNotification *) noti
{
    NSArray* array=[noti object];
    
    [currenttoneArrary removeAllObjects];
    
    for (id obj in  array) {
        [currenttoneArrary addObject:obj];
    }
    
    [self play];
}

-(void)EventDirect:(NSNotification *) noti
{
    NSNumber* direct =[noti object];
    _directFlute =direct.intValue;
    if (_isPlay==TRUE) {
        [self stop];
    }
    [self play];
    
}



-(NSString *)checkCurrentFinder

{
    BOOL boolcheck =YES;
    NSString * tone;
    //先检查是否有mic存在
    if (_isBlow==YES) {
        for ( id key in finderSettingDictionary  ) {
            boolcheck =YES;
            tone= key;
            id value=[finderSettingDictionary valueForKey:key];
            
            //检查手机位置当前状态
            NSNumber *dirctdef =[value objectAtIndex:0];
            // NSLog(@"dirctdef =%d _directFlute=%d" ,dirctdef.intValue,_directFlute);
            if (dirctdef.intValue ==_directFlute) {
                // NSLog(@"finderdictionary =%@ " ,[value componentsJoinedByString:@""]);
                for (int i=0; i< currenttoneArrary.count; i++) {
                    if(![[currenttoneArrary objectAtIndex:i] isEqualToString:[value objectAtIndex:i+1]]){
                        boolcheck=NO;
                        continue;
                    }
                }
                if (boolcheck) {
                    return tone;
                }
                
                
            }
        }
    }
    return nil;
}

-(void)play
{
    NSString * tone =[self checkCurrentFinder];
    NSLog(@"play tone = %@",tone);
    
    if (tone!=nil  && _isBlow ==YES) {
        _isPlay =TRUE;
        [sm play:tone];
    }else
    {
        _isPlay =FALSE;
        [sm stop];
    }
    
}
-(void)stop
{
    _isPlay =FALSE;
    [sm stop];
}

@end
