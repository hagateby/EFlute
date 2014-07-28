//
//  SettingMasterViewController.h
//  EFlute
//
//  Created by liuwh on 14-7-2.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFluteManager.h"

@interface SettingMasterViewController : UIViewController{

  
    __weak IBOutlet UISegmentedControl *segmentBlowPiont;
    
    __weak IBOutlet UISlider *sliderBlowThresholdValue;
    
    __weak IBOutlet UIPickerView *pickerToneLvl;
    
    
    EFluteManager * ef;
    
int blowPiont;
//调式
int tonelvl;
//方向
int directFlute ;
    
    //麦克风检测阀值
double blowThresholdValue;
    
    
}
- (IBAction)segmentBlowPion_ValueChanged:(id)sender;

- (IBAction)sliderBlowThresholdValue_change:(id)sender;

@end
