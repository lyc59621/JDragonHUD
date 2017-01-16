//
//  JDragonLoadHUD.h
//  JDragonHUD
//
//  Created by JDragon on 2017/1/4.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDragonLoadHUD : UIView


@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *message;
@property (assign,nonatomic) float radius;

- (id)initWithTitle:(NSString*)title message:(NSString*)message;
- (id)initWithTitle:(NSString*)title;

- (void)startAnimating;
- (void)stopAnimating;

@end
