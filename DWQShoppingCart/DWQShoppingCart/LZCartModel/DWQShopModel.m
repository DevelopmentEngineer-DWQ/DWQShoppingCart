//
//  DWQShopModel.m
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801
//

#import "DWQShopModel.h"
#import "DWQGoodsModel.h"

@implementation DWQShopModel

- (void)configGoodsArrayWithArray:(NSArray*)array; {
    if (array.count > 0) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            DWQGoodsModel *model = [[DWQGoodsModel alloc]init];
            
            
            model.count = [[dic objectForKey:@"count"] integerValue];
            model.goodsID = [dic objectForKey:@"goodsId"];
            model.goodsName = [dic objectForKey:@"goodsName"];
            model.price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realPrice"]];
            
            if ([dic objectForKey:@"goodsPic"]) {
                model.image=[UIImage imageNamed:[dic objectForKey:@"goodsPic"]];
            }
            
            [dataArray addObject:model];
        }
        
        _goodsArray = [dataArray mutableCopy];
    }
}
@end
