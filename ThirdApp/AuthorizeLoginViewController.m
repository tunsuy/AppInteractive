//
//  AuthorizeLoginViewController.m
//  ThirdApp
//
//  Created by tunsuy on 4/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "AuthorizeLoginViewController.h"
#import "ExtensionHandle.h"
#import "MOAInfoViewController.h"

@interface AuthorizeLoginViewController ()

@property (nonatomic, strong) UIButton *authorizeLoginBtn;
@property (nonatomic, strong) UILabel *thirdName;

@end

@implementation AuthorizeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick:)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    _authorizeLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    _authorizeLoginBtn.backgroundColor = [UIColor orangeColor];
    [_authorizeLoginBtn setTitle:@"授权并登陆" forState:UIControlStateNormal];
    [_authorizeLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _authorizeLoginBtn.layer.cornerRadius = 20.f;
    [_authorizeLoginBtn addTarget:self action:@selector(authorizeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_authorizeLoginBtn];
    
    _thirdName = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    _thirdName.textAlignment = NSTextAlignmentCenter;
    _thirdName.text = @"口袋助理";
    [self.view addSubview:_thirdName];
    
}

- (void)authorizeLoginBtnClick:(UIButton *)btn {
//    __weak typeof(self) weakself = self;
//    [ExtensionHandle requestToServerForPersonInfoWithCallback:^(id result){
//        if ([result isKindOfClass:[NSMutableDictionary class]]) {
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                MOAInfoViewController *moaInfoVC = [[MOAInfoViewController alloc] init];
//                [weakself.navigationController pushViewController:moaInfoVC animated:NO];
//            });
//        }
//    }];
    
    MOAInfoViewController *moaInfoVC = [[MOAInfoViewController alloc] init];
    [self.navigationController pushViewController:moaInfoVC animated:NO];
}

- (void)cancelBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
