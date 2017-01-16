//
//  JDragonLoadHUD.m
//  JDragonHUD
//
//  Created by JDragon on 2017/1/4.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "JDragonLoadHUD.h"
#define WIDTH_MARGIN 20
#define HEIGHT_MARGIN 20



@interface JDragonLoadHUD ()

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign) BOOL hidden;



@end
@implementation JDragonLoadHUD
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithTitle:(NSString*)title message:(NSString*)message
{
    
    if(self = [super initWithFrame:CGRectMake(0, 0, 280, 200)]){
        
        _title = [title copy];
        _message = [message copy];
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activity];
        _hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithTitle:(NSString*)title
{
    self = [self initWithTitle:title message:nil];
    if(self)
    {
        
    }
    return self;
}
- (void) drawRect:(CGRect)rect {
    
    if(_hidden) return;
    int width, rWidth, rHeight, x;
    
    
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    UIFont *messageFont = [UIFont systemFontOfSize:12];
    CGSize s1 =  [_title boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGSize s2 =  [_message boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    if([_title length] < 1) s1.height = 0;
    if([_message length] < 1) s2.height = 0;
    
    rHeight = (s1.height + s2.height + (HEIGHT_MARGIN*2) + 10 + _activity.frame.size.height);
    rWidth = width = (s2.width > s1.width) ? (int) s2.width : (int) s1.width;
    rWidth += WIDTH_MARGIN * 2;
    x = (280 - rWidth) / 2;
    
    _activity.center = CGPointMake(280/2,HEIGHT_MARGIN + _activity.frame.size.height/2);
    
    
    //DLog(@"DRAW RECT %d %f",rHeight,self.frame.size.height);
    
    //绘制圆角矩形
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9] set];
    CGRect r = CGRectMake(x, 0, rWidth,rHeight);
    [JDragonLoadHUD drawRoundRectangleInRect:r
                                  withRadius:10.0
                                       color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    
    
    r = CGRectMake(x+WIDTH_MARGIN, _activity.frame.size.height + 10 + HEIGHT_MARGIN, width, s1.height);
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    textStyle.alignment = NSTextAlignmentCenter;
    
    //绘制文本 title
    [[UIColor whiteColor] set];
    [_title drawInRect:r withAttributes:@{NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    CGSize  s = [_title sizeWithAttributes:@{NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:textStyle}];
    
 
    //绘制文本 message
    r.origin.y += s.height+5;
    r.size.height = s2.height;
    [_message drawInRect:r withAttributes:@{NSFontAttributeName:messageFont,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    [self setNeedsDisplay];
}
-(void)setMessage:(NSString *)message
{
    _message = [message copy];
    [self setNeedsDisplay];
}
-(void)setRadius:(float)radius
{
    if (_radius!=radius) {
        _radius = radius;
    }
    [self setNeedsDisplay];
}
- (void)startAnimating{
    if(!_hidden) return;
    _hidden = NO;
    [self setNeedsDisplay];
    [_activity startAnimating];
}
- (void)stopAnimating{
    if(_hidden) return;
    _hidden = YES;
    [self setNeedsDisplay];
    [_activity stopAnimating];
}
+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    
    CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}
//拿到当前view的vc
- (UIViewController *)viewController
{
    id nextResponder = [self nextResponder];
    while(nextResponder)
    {
        nextResponder = [nextResponder nextResponder];
        NSLog(@"nextResponder ====%@",nextResponder);
        
        if ( [nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nextResponder;
}

@end
