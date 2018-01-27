//
//  PageViewControllerActionItem.m
//  UIPageViewControllerDemo
//
//  Created by Four on 2018/1/27.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "PageViewControllerActionItem.h"

@interface PageViewControllerActionItem ()

@property (copy, nonatomic) NSString *pReusableIdentifie;

@property (strong, nonatomic) UIViewController *pViewControllerLeft;

@property (strong, nonatomic) UIViewController *pViewControllerRight;

@end

@implementation PageViewControllerActionItem
    
- (instancetype)initWithLeftViewController:(UIViewController *)left rightViewController:(UIViewController *)right reusableIdentifie:(NSString *)identifie
{
    self = [super init];
    if (self) {
        
        self.pViewControllerLeft = left;
        
        self.pViewControllerRight = right;
        
        self.pReusableIdentifie = identifie;
    }
    return self;
}
    
#pragma mark - public
- (UIViewController *)viewControllerRight {
    
    return self.pViewControllerRight;
}
    
- (UIViewController *)viewControllerLeft {
    
    return self.pViewControllerLeft;
}
    
- (NSString *)reusableIdentifie {
    
    return self.pReusableIdentifie;
}
    
- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@", @{@"pReusableIdentifie" : self.pReusableIdentifie}];
}

    @end
