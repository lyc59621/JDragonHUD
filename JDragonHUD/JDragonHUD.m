//
//  JDragonHUD.m
//  JDragonHUD
//
//  Created by JDragon on 2017/1/9.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "JDragonHUD.h"
#import "JDragonLoadHUD.h"
#import "JDragonTipHUD.h"

#define ActivityViewTag                0x98751234
#define HudViewTag                     0x98751235
#define TipViewTag                     0x98751255


@implementation JDragonHUD

#pragma mark-------------------------------JDragonLoadHUD-----------------------------------

+ (JDragonLoadHUD*)createActivityViewAtCenter:(NSString*)title
{
    JDragonLoadHUD *HUD = [[JDragonLoadHUD alloc] initWithTitle:title ];
    UIView  *currentView = [[self class] getCurrentUIVC].view;
    HUD.tag = ActivityViewTag;
    [currentView addSubview:HUD];
    CGFloat  y= (currentView.frame.size.height-HUD.frame.size.height)/2;
    CGFloat  left= (currentView.frame.size.width-HUD.frame.size.width)/2;
    CGRect frame = currentView.frame;
    frame.origin.y = y;
    frame.origin.x = left;
    HUD.frame = frame;
    return HUD;
}
+ (JDragonLoadHUD*)createActivityViewAtCenter
{
    return [self createActivityViewAtCenter:nil];
}
+ (JDragonLoadHUD*)getActivityViewAtCenter
{
    UIView* view = [self viewWithTagNotDeepCounting:ActivityViewTag];
    if (view != nil && [view isKindOfClass:[JDragonLoadHUD class]]){
        
        return (JDragonLoadHUD*)view;
    }
    else
    {
        return nil;
    }
}
+ (void)showActivityViewAtCenter
{
    [self showActivityViewAtCenter:nil];
}

+ (void)showActivityViewAtCenter:(NSString*)title
{
    JDragonLoadHUD* activityView = [self getActivityViewAtCenter];
    
    if (activityView == nil){
        
        activityView = [self createActivityViewAtCenter:title?title:@"Loading..."];
    }
    [activityView startAnimating];
}

+ (void)hideActivityViewAtCenter
{
    JDragonLoadHUD* activityView = [self getActivityViewAtCenter];
    [activityView removeFromSuperview];
}
#pragma mark-------------------------------JDragonTipHUD-----------------------------------

+ (void)showTipViewAtCenter:(NSString*)title{
    
    [self showTipViewAtCenter:title posY:0];
}
+ (void)showTipViewAtCenter:(NSString*)title posY:(CGFloat)y{
    
    [self showTipViewAtCenter:title posY:y timer:0];
}
+ (void)showTipViewAtCenter:(NSString*)title timer:(int)aTimer
{
    [self showTipViewAtCenter:title posY:0 timer:aTimer];
}
+ (void)showTipViewAtCenter:(NSString*)title  posY:(CGFloat)y timer:(int)aTimer
{
    //规定时间
    JDragonTipHUD *activityView = [self getTipView];
    
    if (activityView) {
        [activityView dismiss:NO];
    }
    //默认posY为0,即黄金分割处
    activityView = [[JDragonTipHUD alloc] initWithView:[[self class] getCurrentUIVC].view message:title posY: y>0?y:0];
    activityView.layer.zPosition = 11;
    activityView.tag = TipViewTag;
    activityView.showTime = aTimer;
    [activityView show];
}
+ (void)showTipViewAtCenter:(NSString *)title message:(NSString *)message
{
    [self showTipViewAtCenter:title message:message posY:0];
}
+ (void)showTipViewAtCenter:(NSString *)title message:(NSString *)message posY:(CGFloat)y
{
    JDragonTipHUD *activityView = [self getTipView];
    
    if (activityView) {
        [activityView dismiss:NO];
    }
    activityView = [[JDragonTipHUD alloc] initWithView:[[self class] getCurrentUIVC].view title:title message:message posY:y];
    activityView.layer.zPosition = 11;
    activityView.tag = TipViewTag;
    [activityView show];
}

+ (void)hideTipView{
    
    JDragonTipHUD *activityView = [self getTipView];
    [activityView dismiss:YES];
}
+ (JDragonTipHUD *)getTipView
{
    UIView* view = [self viewWithTagNotDeepCounting:TipViewTag];
    
    if (view != nil && [view isKindOfClass:[JDragonTipHUD class]]){
        return (JDragonTipHUD *)view;
    }
    else {
        return nil;
    }
}

//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentWindowVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return  result;
}
+(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }
    return superVC;
}
+ (UIView *)viewWithTagNotDeepCounting:(NSInteger)tag
{
    for (UIView *view in [[self class] getCurrentUIVC].view.subviews)
    {
        if (view.tag == tag) {
            return view;
            break;
        }
    }
    return nil;
}
@end
