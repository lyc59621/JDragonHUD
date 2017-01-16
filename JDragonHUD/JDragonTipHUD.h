//
//  JDragonTipHUD.h
//  JDragonHUD
//
//  Created by JDragon on 2017/1/4.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JDTipLabelMaxWidth      160.0f
#define JDTipTitleMaxWidth      200.0f
#define JDTipPosYGoldPoint      0


@interface JDragonTipHUD : UIView

@property (nonatomic, assign) CGFloat showTime;
@property (nonatomic, assign) BOOL dimBackground;


- (id)initWithView:(UIView *)view message:(NSString *)message posY:(CGFloat)posY;
- (id)initWithView:(UIView *)view title:(NSString *)title message:(NSString *)message posY:(CGFloat)posY;
- (void)show;
- (void)dismiss:(BOOL)animation;
@end
