//
//  SoundManager.m
//  test3
//
//  Created by pmoiphone on 14-6-10.
//  Copyright (c) 2014年 pmoiphone. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SoundManager.h"
#import <openal/al.h>
#import <OpenAL/alc.h>
#import <openal/oalMacOSX_OALExtensions.h>
#import <AVFoundation/AVFoundation.h>
@implementation SoundManager

-(void)test
{
    
        
        [self initOpenAL];
        soundDirctionary =[NSMutableDictionary dictionaryWithCapacity: 6];
        ToneArray =[NSArray arrayWithObjects:@"E4",
                    nil];
        
        for (id obj in ToneArray) {
            [self addFileToAudio: obj];
        }
    
    
}

-(void)play :(NSString *)filename
{
    NSString * path =[[NSBundle mainBundle] pathForResource:filename ofType:@"aif"];
    NSURL * afUrl =[NSURL fileURLWithPath:path];
    UInt32 soundID;
    //AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(afUrl), &soundID);
    //AudioServicesPlayAlertSound(soundID);
    
   
     
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:afUrl
                                                             error:nil];
        //[audioPlayer setDelegate:self];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:filename
                                                          ofType:@"aif"];
    
    [audioPlayer play];

}

-(void)stop
{
    [audioPlayer stop];

}



-(SoundManager *)init {
    self=[super init];
    if (self != NULL) {
        
        [self initOpenAL];
           soundDirctionary =[NSMutableDictionary dictionaryWithCapacity: 6];
           ToneArray =[NSArray arrayWithObjects:@"A2", @"A3" ,@"A4",
                    @"B2",@"B3",@"B4",
                    @"C3",@"C4",@"C5",
                    @"D3",@"D4",
                    @"E3",@"E4",
                    @"F3",@"F3Sharp",@"F4",@"F4Sharp",
                    @"G2",@"G3",@"G4",
                    nil];
        
        for (id obj in ToneArray) {
            [self addFileToAudio: obj];
        }
    
    }
    return self;

}

-(void)addFileToAudio:(NSString * ) fileName
{
    NSUInteger bufferID;
    NSUInteger sourceID;
    
    
    
    AudioFileID fileID;
     
    //fileName =[[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSString * fileurl =[[NSBundle mainBundle] pathForResource:fileName ofType:@"aif"];
    
    fileID=[self openAudioFile:fileurl];
    
    sourceID =[self audioFileToBuffer:fileID FileName:fileName];
    
   // sourceID =[self audioAddBufferToSource:bufferID];
    
   // [soundDirctionary setObject:[NSNumber numberWithUnsignedInt:sourceID] forKey:fileName];
    
     [soundDirctionary setObject:[NSNumber numberWithInteger:sourceID]  forKey:fileName];
}


-(void) initOpenAL
{
    //initialization
    mDevice =alcOpenDevice(NULL);
    //select the prefered device
    if (mDevice) {
        //use the device to make a context
        mContext=alcCreateContext(mDevice,NULL);
        //set my context to the currently active one
        alcMakeContextCurrent(mContext);
    }
    
}

-(AudioFileID) openAudioFile:(NSString *)filePath{
    AudioFileID  outAFID;
    NSURL *afUrl=[NSURL fileURLWithPath:filePath];
#if TARGET_OS_IPHONE
    OSStatus result =AudioFileOpenURL((CFURLRef) CFBridgingRetain(afUrl), kAudioFileReadPermission,0, &outAFID );
#else
    OSStatus result=AudioFileOpenURL( afUrl,fsRdPerm,0,&outAFID);
#endif
    if (result !=0) {
        NSLog(@"cannot open file %@" ,filePath);
        
    }
    return outAFID;
}

-(UInt32)audioFileSize:(AudioFileID)fileDescriptor{
    UInt64 outDataSize =0;
    UInt32 thePropSize=sizeof(UInt64);
    OSStatus result=AudioFileGetProperty(fileDescriptor,kAudioFilePropertyAudioDataByteCount,&thePropSize,&outDataSize);
    if(result!=0)
        NSLog(@"connot find file size");
    return (UInt32)outDataSize;
    
}



-(NSUInteger )audioFileToBuffer:(AudioFileID) fileID FileName:(NSString *)fileName  {
    
    UInt32 fileSize =[self audioFileSize : fileID];
    
    unsigned char * outData =malloc(fileSize);
    
    OSStatus result =noErr;
    
    NSUInteger  bufferID;
    
    
    result =AudioFileReadBytes(fileID, false,0,&fileSize,outData);
    
    AudioFileClose(fileID);
    
    if (result!=0)
        
        NSLog(@"cannot load effect :%@", fileName);
    
    alGenBuffers(1,&bufferID);
    
    
    alBufferData(bufferID,AL_FORMAT_STEREO16,outData,fileSize,44100);
    
    [bufferStorageArray addObject:[NSNumber numberWithUnsignedInteger:bufferID]];
    
   
    NSInteger sourceID=  [self audioAddBufferToSource:bufferID];
    
    
    
    
    
    free(outData);
    
    outData=NULL;
    
    return  sourceID;
}

-(NSInteger) audioAddBufferToSource: (NSInteger ) bufferID
{
    NSInteger sourceID;
    ALuint aluint;
    
    alGenSources(1,&aluint);
    
    //alSpeedOfSound(1.0);
    
   // alDopplerVelocity(1.0);
    //alDopplerFactor(1.0);
    
    alSourcei(aluint, AL_BUFFER, bufferID);
    
    alSourcef(aluint, AL_PITCH, 1.0f);
    
    alSourcef(aluint, AL_GAIN, 1.0f);
    
    //alSourcef(sourceID, AL_SOURCE_TYPE, AL_STREAMING);
    
   // alSourcef(aluint, AL_LOOPING,AL_FALSE);
    
    sourceID= aluint;
    
    return sourceID;
}
-(void)palySound:(NSString *) soundKey
{
    NSNumber * numVal=[soundDirctionary objectForKey:soundKey];
    if (numVal==nil)
        return;
    NSUInteger sourceID=[numVal unsignedIntValue];
    alSourcePlay(sourceID);
}
-(void)stopSound:(NSString *)soundKey
{
    NSNumber * numVal=[soundDirctionary objectForKey:soundKey];
    if (numVal==nil)
        return;
    NSUInteger sourceID=[numVal unsignedIntValue];
    alSourceStop(sourceID);
    
}

-(void) SetListenervalues

{
    /*
     alListenerfv(AL_POSITION, ListenerPos);
     alListenerfv(AL_VELOCITY, ListenerVel);
     alListenerfv(AL_ORIENTATION, ListenerOri);
     */
}
-(void)clesnUpOpenAL{
    
    //delete the sources
    for (NSNumber * sourceNumber in [soundDirctionary allValues]) {
        NSUInteger sourceID =[sourceNumber unsignedIntValue];
        alDeleteSources(sourceNumber, &sourceID);
        //  [soundDirctionary ];
    }
    
    
    for (NSNumber * bufferNumber in bufferStorageArray) {
        NSUInteger bufferID =[bufferNumber unsignedIntValue];
        alDeleteBuffers(1,&bufferID);
    }
    [bufferStorageArray removeAllObjects];
    
    alcDestroyContext(mContext);
    alcCloseDevice(mDevice);
}



@end
