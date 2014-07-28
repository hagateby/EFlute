//
//  AccelermeterManager.h
//  EFlute
//
//  Created by liuwh on 14-7-2.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccelermeterManager : NSObject
{
    
    UIAccelerometer * accelerometer ;
    
    UIAccelerationValue * accelerValue;
    
    UIAccelerationValue  _speedX;
    
    UIAccelerationValue  _speedY;
    
    UIAccelerationValue  _speedZ;
}
-(id)init;

@end
