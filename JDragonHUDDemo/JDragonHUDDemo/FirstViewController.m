//
//  FirstViewController.m
//  JDragonHUDDemo
//
//  Created by JDragon on 2017/1/16.
//  Copyright © 2017年 JDragon. All rights reserved.
//

#import "FirstViewController.h"
#import "JDragonHUD.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray  *titleArray;
@end

@implementation FirstViewController


-(NSArray*)titleArray
{
    return @[@"Tip弹窗",@"Tip弹窗带title",@"默认HUD",@"自定义titleHUD"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"ssss==%@",self);
    UITableView  *tab = [self.view viewWithTag:98];
    tab.tableFooterView = [UIView new];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellone"];
    cell.textLabel.text =self.titleArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [JDragonHUD showTipViewAtCenter:@"无网络"];
            break;
        case 1:
            [JDragonHUD showTipViewAtCenter:@"无网络" message:@"假的啊"];
            break;
        case 2:
            [JDragonHUD showActivityViewAtCenter];
            break;
        case 3:
            [JDragonHUD showActivityViewAtCenter:@"正在骑马...."];
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
            
        default:
            break;
    }
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
    
    
}
-(void)dismiss
{
    NSLog(@"disMiss");
    
    [JDragonHUD hideTipView];
    [JDragonHUD hideActivityViewAtCenter];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
