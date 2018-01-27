//
//  PageViewControllerAction.m
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "PageViewControllerAction.h"

@interface PageViewControllerAction () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
    
@property (strong, nonatomic) UIPageViewController *pPageViewController;

@property (assign, nonatomic) BOOL isBefore; // 向前翻页

@property (assign, nonatomic) BOOL pageInAnimation; // 是否在动画中

@property (assign, nonatomic) NSInteger index; // 记录下标

@property (assign, nonatomic) NSInteger flag; // 标志位

@property (strong, nonatomic) NSMutableSet<PageViewControllerActionItem *> *reusableSet; // 复用池

@property (strong, nonatomic) PageViewControllerActionItem *oldItem; // 旧值

@property (strong, nonatomic) PageViewControllerActionItem *item; // 新值

@property (readonly, nonatomic) NSInteger pageIndex; // 页标(向前向后翻页是用到)

@property (assign, nonatomic) BOOL startPageAnimation; // 开始翻页 (防止快速翻页 导致复用池为空)

@end

@implementation PageViewControllerAction
    
- (UIPageViewController *)pPageViewController {
    
    if (!_pPageViewController) {
        
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMid)};
        
        _pPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        // 双面
        _pPageViewController.doubleSided = true;
    }
    
    return _pPageViewController;
}
    
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.reusableSet = [NSMutableSet set];
        
        self.pPageViewController.delegate = self;
        
        self.pPageViewController.dataSource = self;
    }
    return self;
}
    
#pragma mark - UIPageViewControllerDataSource
// 因为是 双面的 所以 翻页 会有两次调用
#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    self.isBefore = true; // 记录标志位
    
    if (self.pageInAnimation || self.index <= 0) { // 在翻页动画 或者 翻到第一页不可翻动
        
        return nil;
    }
    
    return [self contentViewControllerAtIndex:self.pageIndex];
}
    
#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    self.isBefore = false;
    
    if (self.pageInAnimation || self.index >= self.dataCount - 1) { // 翻页动画中 或者最后一页
        
        return nil;
    }
    
    return [self contentViewControllerAtIndex:self.pageIndex];
}
    
#pragma mark 获取 viewcontroller
- (UIViewController *) contentViewControllerAtIndex:(NSInteger)index {
    
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerAction:itemAtIndex:)]) {
        
        self.flag ++;
        
        if (self.flag % 2 == 1 && self.startPageAnimation == false) { // 奇数调用 偶数不用, 非翻页动画中
            
            // 获取item 并且赋值给 self.item
            [self dequeueItemAtIndex:index];
        }
        
        self.flag = self.flag == 100 ? 0 : self.flag;
        
        self.startPageAnimation = true;
        
        // 向左向右翻页控制器调用的顺序的不一样的
        if (self.isBefore) {
            
            return self.flag % 2 == 0 ? self.item.viewControllerLeft : self.item.viewControllerRight;
        }
        
        return self.flag % 2 == 1 ? self.item.viewControllerLeft : self.item.viewControllerRight;
        
    } else {
        
        return nil;
    }
}
    
#pragma mark - UIPageViewControllerDelegate
#pragma mark 开始翻动
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    self.pageInAnimation = true;
    
    if ([self.delegate respondsToSelector:@selector(pageViewControllerActionAnimationBegin:pageIndex:)]) {
        
        [self.delegate pageViewControllerActionAnimationBegin:self pageIndex:self.pageIndex];
    }
}
    
#pragma mark 翻页结束
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    self.pageInAnimation = false;
    
    self.startPageAnimation = false;
    
    // completed == true 表示 翻页了
    if (completed) {
        
        // 下标
        NSInteger index = self.isBefore ? -1 : 1;
        
        self.index += index;
        
        // 动画完成 reusableArray 添加 olditem ,olditem 赋新值
        if ([previousViewControllers containsObject:self.oldItem.viewControllerLeft]) {
            
            [self reusableArrayAddItem:self.oldItem];
            
            self.oldItem = self.item;
        }
        
    } else {
        
        // 没有翻页 那么 item 放到 池子中,item 改为 olditem
        [self reusableArrayAddItem:self.item];
        
        self.item = self.oldItem;
    }
    
    // 回调
    if ([self.delegate respondsToSelector:@selector(pageViewControllerActionAnimationDidEnd:pageIndex:completed:)]) {
        
        [self.delegate pageViewControllerActionAnimationDidEnd:self pageIndex:self.index completed:completed];
    }
}
    
#pragma mark - 获取 item
- (void) dequeueItemAtIndex:(NSInteger)index {
    
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerAction:itemAtIndex:)]) {
        
        // 从代理拿 代理会从复用池中查找
        PageViewControllerActionItem *item = [self.dataSource pageViewControllerAction:self itemAtIndex:index];
        
        self.item = item;
    }
}
    
#pragma mark - 获取下标
- (NSInteger)pageIndex {
    
    NSInteger flag = self.isBefore ? -1 : 1;
    
    NSInteger index = self.index + flag;
    
    return index;
}
    
#pragma mark - 添加到复用池中
- (void) reusableArrayAddItem:(PageViewControllerActionItem *)item {
    
    [self.reusableSet addObject:item];
}
    
#pragma mark - public
- (UIPageViewController *)pageViewController {
    
    return self.pPageViewController;
}
    
- (UIView *)pageView {
    
    return self.pPageViewController.view;
}
 
#pragma mark - 设置指定位置的page
- (void) setPageAtIndex:(NSInteger)index {
    
    // 判断翻页方向
    UIPageViewControllerNavigationDirection direction = index < self.index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    
    self.pageInAnimation = true;
    
    __weak typeof(self) weakSelf = self;
    
    // 回调 表示开始
    if ([self.delegate respondsToSelector:@selector(pageViewControllerActionAnimationBegin:pageIndex:)]) {
        
        [self.delegate pageViewControllerActionAnimationBegin:self pageIndex:index];
    }
    
    [self.pPageViewController setViewControllers:@[self.item.viewControllerLeft,self.item.viewControllerRight] direction:direction animated:true completion:^(BOOL finished) {
        
        weakSelf.pageInAnimation = false;
        
        if ([weakSelf.delegate respondsToSelector:@selector(pageViewControllerActionAnimationDidEnd:pageIndex:completed:)]) {
            
            [weakSelf.delegate pageViewControllerActionAnimationDidEnd:weakSelf pageIndex:weakSelf.pageIndex completed:true];
        }
    }];
}
    
- (void) loadData {
    
    [self dequeueItemAtIndex:self.index];
    
    if (!self.oldItem) {
        
        self.oldItem = self.item;
    }
    
    [self.pPageViewController setViewControllers:@[self.item.viewControllerLeft,self.item.viewControllerRight]
                                       direction:UIPageViewControllerNavigationDirectionReverse
                                        animated:NO
                                      completion:nil];
}
    
- (PageViewControllerActionItem *) dequeueReusableItemWithIdentifier:(NSString *)identifie {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reusableIdentifie == %@", identifie];
    
    NSSet *set = [self.reusableSet filteredSetUsingPredicate:predicate];
    
    PageViewControllerActionItem *item = set.allObjects.firstObject;
    
    if (item) { // 找到 从池子中删除 并return
        
        [self.reusableSet removeObject:item];
    }
    
    return item;
}
    
- (void) scrollAtIndex:(NSInteger)index {
    
    if (index == self.index || self.pageInAnimation) { // 当前页 和动画中都不执行
        
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerAction:itemAtIndex:)]) {
        
        // 先查找复用池 添加到显示数组中, 并且赋值给 self.item
        [self dequeueItemAtIndex:index];
        
        // 将旧值保存到复用池中
        [self reusableArrayAddItem:self.oldItem];
        
        self.oldItem = self.item;
        
        [self setPageAtIndex:index];
        
        self.index = index;
    }
}
    
- (NSArray *)visibleItems {
    
    return [NSSet setWithObjects:self.item, self.oldItem, nil].allObjects;
}
    
@end
