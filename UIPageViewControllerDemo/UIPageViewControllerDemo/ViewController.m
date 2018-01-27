//
//  ViewController.m
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "ViewController.h"

#import "PageViewControllerAction.h"

#import "ContentViewController.h"

@interface ViewController ()<PageViewControllerActionDataSource,PageViewControllerActionDelegate>
    
@property (nonatomic, strong) PageViewControllerAction *pageViewControllerAction;

@end

@implementation ViewController
    
- (PageViewControllerAction *)pageViewControllerAction {
    
    if (!_pageViewControllerAction) {
        
        _pageViewControllerAction = [[PageViewControllerAction alloc] init];
    }
    
    return _pageViewControllerAction;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.pageViewControllerAction.dataCount = 10;
    
    self.pageViewControllerAction.dataSource = self;
    
    self.pageViewControllerAction.delegate = self;
    
    self.pageViewControllerAction.pageView.frame = CGRectMake(100, 100, 300, 300);
    
    self.pageViewControllerAction.pageView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.pageViewControllerAction.pageView];
    
    // 初始化数据
    [self.pageViewControllerAction loadData];
}
    
#pragma mark - ATPageViewControllerActionDataSource
- (PageViewControllerActionItem *)pageViewControllerAction:(PageViewControllerAction *)action itemAtIndex:(NSInteger)index {
    
    NSString *reusableIdentifie = index % 2 == 0 ? @"pageViewControllerAction" : @"reusableIdentifie";
    
    PageViewControllerActionItem *item = [action dequeueReusableItemWithIdentifier:reusableIdentifie];
    
    if (!item) {
        
        ContentViewController *vc1 = [[ContentViewController alloc] init];
        
        ContentViewController *vc2 = [[ContentViewController alloc] init];
        
        item = [[PageViewControllerActionItem alloc] initWithLeftViewController:vc1 rightViewController:vc2 reusableIdentifie:reusableIdentifie];
        
        NSLog(@"🍎🍎 创建 🍎🍎");
    }
    
    UIColor *color1 = [reusableIdentifie isEqualToString:@"pageViewControllerAction"] ? [UIColor redColor] : [UIColor purpleColor];
    
    item.viewControllerLeft.view.backgroundColor = color1;
    
    UIColor *color2 = [reusableIdentifie isEqualToString:@"pageViewControllerAction"] ? [UIColor yellowColor] : [UIColor cyanColor];
    
    item.viewControllerRight.view.backgroundColor = color2;
    
    if([item.viewControllerLeft isKindOfClass:[ContentViewController class]]) {
        
        ContentViewController *vc = (ContentViewController *)item.viewControllerLeft;
        
        vc.text = [[NSString alloc] initWithFormat:@"我是左边第%@页",@(index)];
    }
    
    if([item.viewControllerRight isKindOfClass:[ContentViewController class]]) {
        
        ContentViewController *vc = (ContentViewController *)item.viewControllerRight;
        
        vc.text = [[NSString alloc] initWithFormat:@"我是右边第%@页",@(index)];
    }
    
    return item;
}
    
#pragma mark - ATPageViewControllerActionDelegate
- (void)pageViewControllerActionAnimationDidEnd:(PageViewControllerAction *)action pageIndex:(NSInteger)index completed:(BOOL)completed {
    
}
    
- (void)pageViewControllerActionAnimationBegin:(PageViewControllerAction *)action pageIndex:(NSInteger)index {
    
    
}

@end
