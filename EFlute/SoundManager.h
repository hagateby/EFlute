//
//  SoundManager.h
//  test3
//
//  Created by pmoiphone on 14-6-10.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <openal/al.h>
#import <OpenAL/alc.h>
#import <openal/oalMacOSX_OALExtensions.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject
{
    NSMutableArray * bufferStorageArray;
    NSMutableDictionary * soundDirctionary;
    NSArray * ToneArray;
    ALCcontext * mContext;
    ALCdevice *mDevice;
    
    
    BOOL isPlaying;
    
    AVAudioPlayer *audioPlayer;    
}

-(void)test;

-(void)play:(NSString *) filßename;

-(void)stop;

-(void)addFileToAudio:(NSString * ) fileName;

-(void) initOpenAL;

-(AudioFileID) openAudioFile:(NSString *)filePath;

-(UInt32)audioFileSize:(AudioFileID)fileDescriptor;

-(NSUInteger )audioFileToBuffer:(AudioFileID) fileID FileName:(NSString *)fileName;

-(NSInteger) audioAddBufferToSource: (NSInteger ) bufferID;

-(void)palySound:(NSString *) soundKey;

-(void)stopSound:(NSString *)soundKey;

-(void) SetListenervalues;

-(void)clesnUpOpenAL;




@end
