//
//  DWQTableHeaderView.h
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801

#import <UIKit/UIKit.h>

typedef void(^buttonClickBlock)(BOOL select);
@interface DWQTableHeaderView : UITableViewHeaderFooterView

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)buttonClickBlock dwqClickBlock;
@property (assign,nonatomic)BOOL select;
@end
