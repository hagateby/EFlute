//
//  SettingMasterViewController.m
//  EFlute
//
//  Created by liuwh on 14-7-2.
//  Copyright (c) 2014年 liuwh. All rights reserved.
//

#import "SettingMasterViewController.h"




@implementation SettingMasterViewController
{


}


- (void)viewDidLoad
{
    [super viewDidLoad];
	NSArray *list = [NSArray arrayWithObjects:@"麦克风选择：",@"麦克风灵敏度：",@"调式选择",@"选择IPOD歌曲",nil];
    
    //ef =[EFluteManager alloc];
    // 设置tableView的数据源
    //[_tblbaseSetting dataSource];
    
    ef =[EFluteManager sharedInstance];
    [self initview];
    
}

-(void)initview
{
   
    //［segmentBlowPiont initWithItems:segmentarr];
    [segmentBlowPiont removeAllSegments];
    [segmentBlowPiont insertSegmentWithTitle:@"左侧" atIndex:0 animated:YES];
    [segmentBlowPiont insertSegmentWithTitle:@"右侧" atIndex:1 animated:YES];
    segmentBlowPiont.selectedSegmentIndex=1;
    
    
    sliderBlowThresholdValue.maximumValue =0;
    sliderBlowThresholdValue.maximumValue =1;
    
    /*
    NSString* CellIdentifier = @"Cell";
    UITableViewCell * cell = [tblbaseSetting dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text=@"话题";
    */
  
    return ;
  
}
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
   
}


- (IBAction)segmentBlowPion_ValueChanged:(id)sender {
  
    ef.blowPiont =[segmentBlowPiont selectedSegmentIndex];
}

- (IBAction)sliderBlowThresholdValue_change:(id)sender {
    ef.blowThresholdValue =[sliderBlowThresholdValue value];
}


@end
