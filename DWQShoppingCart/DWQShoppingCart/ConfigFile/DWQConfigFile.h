//
//  DWQConfigFile.h
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801


#ifndef DWQConfigFile_h
#define DWQConfigFile_h
#import "UIViewExt.h"

//16进制RGB的颜色转换
#define DWQColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define DWQColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//红色
#define BASECOLOR_RED [UIColor \
colorWithRed:((float)((0xED5565 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xED5565 & 0xFF00) >> 8))/255.0 \
blue:((float)(0xED5565 & 0xFF))/255.0 alpha:1.0]



#define DWQSCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define DWQSCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define DWQNaigationBarHeight 64
#define DWQTabBarHeight 49
#define DWQTableViewHeaderHeight 40

#define  TAG_CartEmptyView 100


static NSString *dwq_BackButtonString = @"back_button";
static NSString *dwq_Bottom_UnSelectButtonString = @"cart_unSelect_btn";
static NSString *dwq_Bottom_SelectButtonString = @"cart_selected_btn";
static NSString *dwq_CartEmptyString = @"cart_default_bg";
static NSInteger dwq_CartRowHeight = 100;
#endif /* DWQConfigFile_h */
