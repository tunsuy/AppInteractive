//
//  ViewController.m
//  ThirdApp
//
//  Created by tunsuy on 3/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *jmpToMOABtn;
@property (nonatomic, strong) UILabel *codeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _jmpToMOABtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    _jmpToMOABtn.backgroundColor = [UIColor orangeColor];
    [_jmpToMOABtn setTitle:@"跳转到口袋助理" forState:UIControlStateNormal];
    [_jmpToMOABtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _jmpToMOABtn.layer.cornerRadius = 20.f;
    [_jmpToMOABtn addTarget:self action:@selector(jmpToMOA:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jmpToMOABtn];
    
//    _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 30)];
//    _codeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_codeLabel];
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    if (appDelegate.callbackUrl) {
//        [self showMOACallbackCode:appDelegate.callbackUrl];
//    }
    
}

- (void)jmpToMOA:(UIButton *)btn {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = @(65541);
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString *jmpUrlStr = [[NSString alloc] initWithFormat:@"sangforpocket://com.sangfor.pocket/func=thirdlogin&params=%@&callbackurlscheme=com.tunsuy.third", paramsStr];
    NSString *encodingJmpUrlStr = [jmpUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodingJmpUrlStr];
    [[UIApplication sharedApplication] openURL:url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
