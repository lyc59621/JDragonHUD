//
//  JDragonHUD.h
//  JDragonHUD
//
//  Created by JDragon on 2017/1/9.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JDragonLoadHUD;
@class JDragonTipHUD;
@interface JDragonHUD : UIView


+ (void)showActivityViewAtCenter;
+ (void)showActivityViewAtCenter:(NSString*)title;
+ (void)hideActivityViewAtCenter;
+ (JDragonLoadHUD*)getActivityViewAtCenter;


+ (void)showTipViewAtCenter:(NSString*)title;
+ (void)showTipViewAtCenter:(NSString*)title posY:(CGFloat)y;
+ (void)showTipViewAtCenter:(NSString*)title timer:(int)aTimer;
+ (void)showTipViewAtCenter:(NSString*)title message:(NSString *)message posY:(CGFloat)y;
+ (void)showTipViewAtCenter:(NSString*)title message:(NSString *)message;
+ (void)hideTipView;
+ (JDragonTipHUD *)getTipView;


@end
