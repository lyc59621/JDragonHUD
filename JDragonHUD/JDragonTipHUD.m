//
//  JDragonTipHUD.m
//  JDragonHUD
//
//  Created by JDragon on 2017/1/4.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "JDragonTipHUD.h"


//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}
#define DefaultTime                     2


@interface JDragonTipHUD ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *fatherView;
@property (nonatomic, strong) NSTimer *titleTimer;
@property (nonatomic, copy)   NSString *labelText;
@property (nonatomic, copy)   NSString *titleText;
@property (nonatomic, assign) CGFloat posY;

@end


@implementation JDragonTipHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) { // 1
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); // 2
    CGContextTranslateCTM (context, CGRectGetMinX(rect), // 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); // 4
    fw = CGRectGetWidth (rect) / ovalWidth; // 5
    fh = CGRectGetHeight (rect) / ovalHeight; // 6
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context); // 12
    CGContextRestoreGState(context); // 13
}

- (id)initWithView:(UIView *)view message:(NSString *)message posY:(CGFloat)posY
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.fatherView = view;
        self.labelText = message;
        _posY = posY;
        _dimBackground = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //每个字0.3s
        _showTime = [message length] * 0.3;
        _showTime = _showTime > DefaultTime ? _showTime : DefaultTime;
        
    }
    return self;
}
- (id)initWithView:(UIView *)view title:(NSString *)title message:(NSString *)message posY:(CGFloat)posY
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.fatherView = view;
        self.labelText = message;
        self.titleText = title;
        _posY = posY;
        _dimBackground = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //每个字0.3s
        _showTime = ([message length] + [title length]) * 0.3;
        _showTime = _showTime > DefaultTime ? _showTime : DefaultTime;
        
    }
    return self;
}
-(void)setShowTime:(CGFloat)showTime
{
    if (showTime<=0) {
        return;
    }
    if (_showTime!=showTime) {
        _showTime = showTime;
    }
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByCharWrapping;
        _label.font = [UIFont systemFontOfSize:15.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (void)show
{
    [self.fatherView addSubview:self];
    self.titleTimer = [NSTimer scheduledTimerWithTimeInterval:_showTime
                                                     target:self
                                                   selector:@selector(dismiss)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         TT_INVALIDATE_TIMER(_titleTimer);
                         [self removeFromSuperview];
                     }];
}
- (void)dismiss:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             TT_INVALIDATE_TIMER(_titleTimer);
                             [self removeFromSuperview];
                         }];
    }else{
        TT_INVALIDATE_TIMER(_titleTimer);
        [self removeFromSuperview];
    }
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //无title
    if ([self.titleText length] == 0)
    {
        //计算文字的size
        CGSize labelSize =[_labelText boundingRectWithSize:CGSizeMake(JDTipTitleMaxWidth,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGSize maskSize = CGSizeMake(labelSize.width+40, labelSize.height+30);
        
        //计算框的center
        CGFloat centerY = 0;
        if (_posY)
        {
            centerY = _posY + maskSize.height;
        }
        else
        {
            //默认取黄金分割
            centerY = 0.382 * self.frame.size.height;
        }
        CGFloat  width = self.frame.size.width;
        
        
        CGRect labelFrame = CGRectMake(width/2-labelSize.width/2, centerY-labelSize.height/2, labelSize.width, labelSize.height);
        CGRect maskFrame = CGRectMake(width/2-maskSize.width/2, centerY-maskSize.height/2, maskSize.width, maskSize.height);
        
        if (_dimBackground) {
            
            size_t gradLocationsNum = 2;
            CGFloat gradLocations[2] = {0.0f, 1.0f};
            CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
            CGColorSpaceRelease(colorSpace);
            
            //Gradient center
            CGPoint gradCenter = CGPointMake(width/2,  centerY);
            //Gradient radius
            //float gradRadius =  (self.bounds.size.height-_posY)*2;
            float gradRadius = 350;
            //Gradient draw
            CGContextDrawRadialGradient (context, gradient, gradCenter,
                                         0, gradCenter, gradRadius,
                                         kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
        
        addRoundedRectToPath(context, maskFrame, 3.0f, 3.0f);
        
        CGFloat black[4] = {0.0, 0.0, 0.0, 0.7f};
        CGContextSetFillColor(context, black);
        CGContextFillPath(context);
        
        self.label.frame = labelFrame;
        self.label.text = _labelText;
        [self addSubview:self.label];
    }
    else
    {
        //title的size
        CGSize titleSize = CGSizeMake(JDTipTitleMaxWidth, 20);
        self.label.font = [UIFont systemFontOfSize:16.0f];
        //计算文字的size
        CGSize labelSize = [_labelText boundingRectWithSize:CGSizeMake(JDTipTitleMaxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        CGSize maskSize = CGSizeMake(JDTipTitleMaxWidth+40, titleSize.height+labelSize.height+30);
        
        //计算框的center
        CGFloat centerY = 0;
        if (_posY)
        {
            centerY = _posY + maskSize.height;
        }
        else
        {
            //默认取黄金分割
            centerY = 0.382 * self.frame.size.height;
        }
        CGFloat  width = self.frame.size.width;
        
        CGRect maskFrame = CGRectMake(width/2-maskSize.width/2, centerY-maskSize.height/2, maskSize.width, maskSize.height);
        CGRect titleFrame = CGRectMake(width/2-titleSize.width/2, maskFrame.origin.y+13, titleSize.width, titleSize.height);
        CGRect labelFrame = CGRectMake(width/2-labelSize.width/2, CGRectGetMaxY(titleFrame)+5, labelSize.width, labelSize.height);
        
        if (_dimBackground) {
            
            size_t gradLocationsNum = 2;
            CGFloat gradLocations[2] = {0.0f, 1.0f};
            CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
            CGColorSpaceRelease(colorSpace);
            
            //Gradient center
            CGPoint gradCenter = CGPointMake(width/2,  centerY);
            //Gradient radius
            //float gradRadius =  (self.bounds.size.height-_posY)*2;
            float gradRadius = 350;
            //Gradient draw
            CGContextDrawRadialGradient (context, gradient, gradCenter,
                                         0, gradCenter, gradRadius,
                                         kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
        
        addRoundedRectToPath(context, maskFrame, 3.0f, 3.0f);
        
        CGFloat black[4] = {0.0, 0.0, 0.0, 0.7f};
        CGContextSetFillColor(context, black);
        CGContextFillPath(context);
        
        self.titleLabel.text = _titleText;
        self.titleLabel.frame = titleFrame;
        [self addSubview:self.titleLabel];
        
        self.label.frame = labelFrame;
        self.label.text = _labelText;
        [self addSubview:self.label];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
