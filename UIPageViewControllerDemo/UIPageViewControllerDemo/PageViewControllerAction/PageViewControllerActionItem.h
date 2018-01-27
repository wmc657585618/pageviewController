//
//  PageViewControllerActionItem.h
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface PageViewControllerActionItem : NSObject
    
@property (readonly, nonatomic) UIViewController *viewControllerLeft;

@property (readonly, nonatomic) UIViewController *viewControllerRight;

@property (readonly, nonatomic) NSString *reusableIdentifie;

/**
 初始化
 
 @param left 左侧控制器
 @param right 右侧控制器
 @param identifie 复用标志
 */
- (instancetype)initWithLeftViewController:(UIViewController *)left rightViewController:(UIViewController *)right reusableIdentifie:(NSString *)identifie;

@end
