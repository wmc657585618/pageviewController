//
//  ContentViewController.m
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ContentViewController

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.frame.size.width - 20;
    
    self.titleLabel.frame = CGRectMake(0, 0, width, 44);
    
    self.titleLabel.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
}

#pragma mark - public
- (void) setText:(NSString *)text {
    
    self.titleLabel.text = text;
}

@end
