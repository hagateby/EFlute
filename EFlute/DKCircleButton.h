//
//  DKCircleButton.h
//  DKCircleButton
//
//  Created by Dmitry Klimkin on 23/4/14.
//  Copyright (c) 2014 Dmitry Klimkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DKCircleButton : UIButton
{
NSTimer * levelTimer;
   
}
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) BOOL animateTap;
@property (nonatomic) BOOL displayShading;
@property (nonatomic) CGFloat borderSize;
@property BOOL ishighlight;

- (void)blink;

@end
