//
//  UIAppearance+Swift.m
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 10/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

#import "UIAppearance+Swift.h"
// UIAppearance+Swift.m
@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
