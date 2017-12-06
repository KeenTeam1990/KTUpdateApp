//
//  KTMainTableViewController.m
//  KTUpdateApp
//  QQ：812144991
//  Email：Keen_Team@163.com
//  GitHub：https://github.com/KeenTeam1990/KTUpdateApp.git
//  Created by keenteam on 2017/12/6.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#import "KTMainTableViewController.h"
#import "KTUpdateApp.h"
@interface KTMainTableViewController ()

@property (nonatomic,strong)NSMutableArray *arrayCellHeight;

@end

@implementation KTMainTableViewController

-(NSMutableArray *)arrayCellHeight{
    if (!_arrayCellHeight) {
        _arrayCellHeight = [NSMutableArray array];
    }
    return _arrayCellHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KTUpdateApp";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"KTUpdateApp"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.arrayCellHeight[indexPath.section] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.numberOfLines = 0;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"测试APPID:1250711932";
        cell.detailTextLabel.text = @"[KTUpdateApp kt_updateWithAPPID:@\"1250711932\" withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {\n}];";
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"测试BundleId:kt.KTUpdateApp";
        cell.detailTextLabel.text = @"[KTUpdateApp kt_updateWithAPPID:nil withBundleId:@\"kt.KTUpdateApp\" block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {\n}];";
    }else{
        cell.textLabel.text = @"什么参数都不传，自动检测";
        cell.detailTextLabel.text = @"[KTUpdateApp kt_updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {\n}];";
    }
    [cell layoutIfNeeded];
    [self.arrayCellHeight addObject:@(CGRectGetHeight(cell.detailTextLabel.frame) + CGRectGetHeight(cell.textLabel.frame))];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"根据APPID检测";
    }else if (section == 1){
        return @"根据项目Bundle Identifier检测";
    }else{
        return @"自动检测";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //=================根据appid检测====================
        [KTUpdateApp kt_updateWithAPPID:@"1250711932" withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
            if (isUpdate) {
                [self showAlertViewTitle:@"APPID检测" subTitle:[NSString stringWithFormat:@"检测到新版本%@,是否更新？",storeVersion] openUrl:openUrl];
            }else{
                NSLog(@"当前版本%@,商店版本%@，不需要更新",currentVersion,storeVersion);
            }
            
        }];
    }else if (indexPath.section == 1){
        //=================根据BundleId检测====================
        [KTUpdateApp kt_updateWithAPPID:nil withBundleId:@"kt.KTUpdateApp" block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
            if (isUpdate) {
                [self showAlertViewTitle:@"BundleId检测" subTitle:[NSString stringWithFormat:@"检测到新版本%@,是否更新？",storeVersion] openUrl:openUrl];
            }else{
                NSLog(@"当前版本%@,商店版本%@，不需要更新",currentVersion,storeVersion);
            }
            
        }];
    }else{
        //=================自动检测====================
        [KTUpdateApp kt_updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
            if (isUpdate) {
                [self showAlertViewTitle:@"自动检测" subTitle:[NSString stringWithFormat:@"检测到新版本%@,是否更新？",storeVersion] openUrl:openUrl];
            }else{
                NSLog(@"当前版本%@,商店版本%@，不需要更新",currentVersion,storeVersion);
            }
            
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showAlertViewTitle:(NSString *)title subTitle:(NSString *)subTitle openUrl:(NSString *)openUrl{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
