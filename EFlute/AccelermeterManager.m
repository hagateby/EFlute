//
//  AccelermeterManager.m
//  EFlute
//
//  Created by liuwh on 14-7-2.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//

#import "AccelermeterManager.h"

@implementation AccelermeterManager
{

}
-(id)init
{
    self=[super init];
    
     accelerometer =[UIAccelerometer sharedAccelerometer];
    
     //设置1.0､60.0 表示1秒接收60次 传感器
     accelerometer.updateInterval =1.0/60.0;
    
    return self;
    
}
-(void)accelerometer:(UIAccelerometer * )accelerometer didAccelerate:(UIAcceleration *) acceleration
{
  //获得加速度要考虑到加速传感器的原点是物理重心，页不是屏幕右上角
    
    //x轴方向的速度加上Ｘ轴方向获得的加速度
      _speedX += acceleration.x;
 
    //y轴方向的速度加上y轴方向获得的加速度
      _speedY += acceleration.y;
    
    //z轴方向的速度加上z轴方向获得的加速度
      _speedZ += acceleration.z;

    
}


@end
