//
//  MOAInfoViewController.m
//  ThirdApp
//
//  Created by tunsuy on 3/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "MOAInfoViewController.h"
#import "ExtensionHandle.h"
#import "ViewController.h"

@interface MOAInfoViewController ()

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userID;

@end

@implementation MOAInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    _userName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_userName];
    
    _userID = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    _userID.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_userID];
    
    __weak typeof(self) weakself = self;
    [ExtensionHandle requestToServerForPersonInfoWithCallback:^(id result){
        if ([result isKindOfClass:[NSMutableDictionary class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.userInfo = result;
                [weakself showUserInfo];
            });
            
        }
        else if ([result isKindOfClass:[NSError class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _userName.text = @"请求接口发生了错误";
            });

        }
    }];
    
}

- (void)showUserInfo {
    if (self.userInfo) {
        _userName.text = [NSString stringWithFormat:@"用户名：%@", self.userInfo[@"Name"]];
        _userID.text = [NSString stringWithFormat:@"用户ID：%@", self.userInfo[@"Userid"]];
    }
}

- (void)backBtnClick:(UIBarButtonItem *)sender {
//    ViewController *rootVC = [[ViewController alloc] init];
//    UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController;
//    if (nav cont) {
//        <#statements#>
//    }
//    [self.navigationController popToViewController:rootVC animated:NO];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
