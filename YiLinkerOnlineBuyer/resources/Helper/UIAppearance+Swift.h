//
//  UIAppearance+Swift.h
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 10/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// UIAppearance+Swift.h
@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
