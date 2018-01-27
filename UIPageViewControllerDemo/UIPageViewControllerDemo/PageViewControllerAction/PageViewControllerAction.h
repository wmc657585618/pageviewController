//
//  PageViewControllerAction.h
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PageViewControllerActionItem.h"

@class PageViewControllerAction;

@protocol PageViewControllerActionDataSource <NSObject>
    
/**
 获取item
 
 @param action action
 @param index item 下标
 @return item
 */
@required
- (PageViewControllerActionItem *)pageViewControllerAction:(PageViewControllerAction *)action itemAtIndex:(NSInteger)index;

@end

@protocol PageViewControllerActionDelegate <NSObject>
    
/**
 翻页动画开始
 */
- (void)pageViewControllerActionAnimationBegin:(PageViewControllerAction *)action pageIndex:(NSInteger)index;

/**
 翻页动画结束

 @param action action
 @param index 下标
 @param completed 是否完成翻页
 */
- (void)pageViewControllerActionAnimationDidEnd:(PageViewControllerAction *)action pageIndex:(NSInteger)index completed:(BOOL)completed;

@end

@interface PageViewControllerAction : NSObject

@property (readonly, nonatomic) UIPageViewController *pageViewController;

@property (assign, nonatomic) NSInteger dataCount;

@property (weak, nonatomic)id<PageViewControllerActionDataSource>dataSource;

@property (readonly, nonatomic) UIView *pageView;

@property (weak, nonatomic)id<PageViewControllerActionDelegate>delegate;

@property (readonly, nonatomic) NSArray<PageViewControllerActionItem *> *visibleItems;
    
// 初始化数据
- (void) loadData;

- (PageViewControllerActionItem *) dequeueReusableItemWithIdentifier:(NSString *)identifie;

/**
 滚动到指定的位置
 
 @param index 下标
 */
- (void) scrollAtIndex:(NSInteger)index;

@end
