//
//  DWQGoodsModel.h
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DWQGoodsModel : NSObject

@property (nonatomic,assign) BOOL select;

@property (assign,nonatomic)NSInteger count;
@property (copy,nonatomic)NSString *goodsID;
@property (copy,nonatomic)NSString *goodsName;
@property (copy,nonatomic)NSString *price;
@property (strong,nonatomic)UIImage *image;

@end
