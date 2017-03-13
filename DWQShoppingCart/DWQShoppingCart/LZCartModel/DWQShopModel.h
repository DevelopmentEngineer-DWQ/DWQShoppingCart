//
//  DWQShopModel.h
//  DWQCartViewController
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801
//

#import <Foundation/Foundation.h>

@interface DWQShopModel : NSObject

@property (assign,nonatomic)BOOL select;
@property (copy,nonatomic)NSString *shopID;
@property (copy,nonatomic)NSString *shopName;
@property (copy,nonatomic)NSString *sID;
@property (strong,nonatomic,readonly)NSMutableArray *goodsArray;

- (void)configGoodsArrayWithArray:(NSArray*)array;
@end
