//
//  DWQCartTableViewCell.h
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801

#import <UIKit/UIKit.h>

@class DWQGoodsModel;
typedef void(^DWQNumberChangedBlock)(NSInteger number);
typedef void(^DWQCellSelectedBlock)(BOOL select);
@interface DWQCartTableViewCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger dwqNumber;
@property (assign,nonatomic)BOOL dwqSelected;

- (void)reloadDataWithModel:(DWQGoodsModel*)model;
- (void)numberAddWithBlock:(DWQNumberChangedBlock)block;
- (void)numberCutWithBlock:(DWQNumberChangedBlock)block;
- (void)cellSelectedWithBlock:(DWQCellSelectedBlock)block;
@end
