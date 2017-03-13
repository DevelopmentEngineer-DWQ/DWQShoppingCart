//
//  DWQCartViewController.m
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801

#import "DWQCartViewController.h"
#import "DWQConfigFile.h"
#import "DWQCartTableViewCell.h"
#import "DWQShopModel.h"
#import "DWQGoodsModel.h"
#import "DWQTableHeaderView.h"


@interface DWQCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
}

@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@end

@implementation DWQCartViewController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    if (_isHasNavitationController == YES) {
        if (self.navigationController.navigationBarHidden == YES) {
            _isHiddenNavigationBarWhenDisappear = NO;
        } else {
            self.navigationController.navigationBarHidden = YES;
            _isHiddenNavigationBarWhenDisappear = YES;
        }
    }
    
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (DWQGoodsModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self DWQSetString:@"￥0.00"];
}

-(void)creatData {
//    for (int i = 0; i < 10; i++) {
//        DWQCartModel *model = [[DWQCartModel alloc]init];
//        
//        model.title = [NSString stringWithFormat:@"测试数据%d",i];
//        model.price = @"100.00";
//        model.number = 1;
//        model.image = [UIImage imageNamed:@"aaa.jpg"];
//        model.dateStr = @"2016.02.18";
//        model.subTitle = @"18*20cm";
//        
//        [self.dataArray addObject:model];
//    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShopCarSources" ofType:@"plist" inDirectory:nil];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSLog(@"%@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count > 0) {
        for (NSDictionary *dic in array) {
            DWQShopModel *model = [[DWQShopModel alloc]init];
            model.shopID = [dic objectForKey:@"id"];
            model.shopName = [dic objectForKey:@"shopName"];
            model.sID = [dic objectForKey:@"sid"];
            [model configGoodsArrayWithArray:[dic objectForKey:@"items"]];
            
     
            [self.dataArray addObject:model];
        }
    }
    
//    if (self.myTableView != nil) {
//        [self.myTableView reloadData];
//    } else {
//        [self setupCartView];
//    }
}
- (void)loadData {
    [self creatData];
    [self changeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isHasTabBarController = self.tabBarController?YES:NO;
    _isHasNavitationController = self.navigationController?YES:NO;
    
#warning 模仿请求数据,延迟2s加载数据,实际使用时请移除更换
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    
    [self setupCustomNavigationBar];
    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_isHiddenNavigationBarWhenDisappear == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (DWQGoodsModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price * model.count;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self DWQSetString:string];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

#pragma mark - 布局页面视图
#pragma mark -- 自定义导航
- (void)setupCustomNavigationBar {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWQSCREEN_WIDTH, DWQNaigationBarHeight)];
    backgroundView.backgroundColor = DWQColorFromRGB(236, 236, 236);
    [self.view addSubview:backgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, DWQNaigationBarHeight - 0.5, DWQSCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"购物车";
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.center = CGPointMake(self.view.center.x, (DWQNaigationBarHeight - 20)/2.0 + 20);
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(300, 44)];
    titleLabel.bounds = CGRectMake(0, 0, size.width + 20, size.height);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 40, 44);
    [backButton setImage:[UIImage imageNamed:dwq_BackButtonString] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
#pragma mark -- 自定义底部视图 
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = DWQColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (_isHasTabBarController == YES) {
        backgroundView.frame = CGRectMake(0, DWQSCREEN_HEIGHT -  2*DWQTabBarHeight, DWQSCREEN_WIDTH, DWQTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, DWQSCREEN_HEIGHT -  DWQTabBarHeight, DWQSCREEN_WIDTH, DWQTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, DWQSCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, DWQTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:dwq_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:dwq_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BASECOLOR_RED;
    btn.frame = CGRectMake(DWQSCREEN_WIDTH - 80, 0, 80, DWQTabBarHeight);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self DWQSetString:@"¥0.00"];
    CGFloat maxWidth = DWQSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, DWQTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, DWQTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)DWQSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *DWQString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [DWQString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [DWQString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return DWQString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight)];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dwq_CartEmptyString]];
    img.center = CGPointMake(DWQSCREEN_WIDTH/2.0, DWQSCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(DWQSCREEN_WIDTH/2.0, DWQSCREEN_HEIGHT/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, DWQSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车为空!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = DWQColorFromHex(0x706F6F);
    [backgroundView addSubview:warnLabel];
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = dwq_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = DWQColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    self.myTableView = table;
    
    if (_isHasTabBarController) {
        table.frame = CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight - 2*DWQTabBarHeight);
    } else {
        table.frame = CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight - DWQTabBarHeight);
    }
    
    [table registerClass:[DWQTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"DWQHeaderView"];
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DWQShopModel *model = [self.dataArray objectAtIndex:section];
    return model.goodsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWQCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWQCartReusableCell"];
    if (cell == nil) {
        cell = [[DWQCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DWQCartReusableCell"];
    }
    
    DWQShopModel *shopModel = self.dataArray[indexPath.section];
    DWQGoodsModel *model = [shopModel.goodsArray objectAtIndex:indexPath.row];
    
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.dwqNumber = number;
        model.count = number;
        
        [shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.dwqNumber = number;
        model.count = number;
        
        [shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        [self verityAllSelectState];
        [self verityGroupSelectState:indexPath.section];
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DWQTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DWQHeaderView"];
    DWQShopModel *model = [self.dataArray objectAtIndex:section];
    NSLog(@">>>>>>%d", model.select);
    view.title = model.shopName;
    view.select = model.select;
    view.dwqClickBlock = ^(BOOL select) {
        model.select = select;
        if (select) {

            for (DWQGoodsModel *good in model.goodsArray) {
                good.select = YES;
                if (![self.selectedArray containsObject:good]) {
                    
                    [self.selectedArray addObject:good];
                }
            }
            
        } else {
            for (DWQGoodsModel *good in model.goodsArray) {
                good.select = NO;
                if ([self.selectedArray containsObject:good]) {
                    
                    [self.selectedArray removeObject:good];
                }
            }
        }
        
        [self verityAllSelectState];

        [tableView reloadData];
        [self countPrice];
    };
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return DWQTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            DWQShopModel *shop = [self.dataArray objectAtIndex:indexPath.section];
            DWQGoodsModel *model = [shop.goodsArray objectAtIndex:indexPath.row];
            
            [shop.goodsArray removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (shop.goodsArray.count == 0) {
                [self.dataArray removeObjectAtIndex:indexPath.section];
            }
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            NSInteger count = 0;
            for (DWQShopModel *shop in self.dataArray) {
                count += shop.goodsArray.count;
            }
            
            if (self.selectedArray.count == count) {
                _allSellectedButton.selected = YES;
            } else {
                _allSellectedButton.selected = NO;
            }
            
            if (count == 0) {
                [self changeView];
            }
            
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (DWQGoodsModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (DWQShopModel *shop in self.dataArray) {
            shop.select = YES;
            for (DWQGoodsModel *model in shop.goodsArray) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
        
    } else {
        for (DWQShopModel *shop in self.dataArray) {
            shop.select = NO;
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0) {
        for (DWQGoodsModel *model in self.selectedArray) {
            NSLog(@"选择的商品>>%@>>>%ld",model,(long)model.count);
        }
    } else {
        NSLog(@"你还没有选择任何商品");
    }
    
}

- (void)verityGroupSelectState:(NSInteger)section {
    
    // 判断某个区的商品是否全选
    DWQShopModel *tempShop = self.dataArray[section];
    // 是否全选标示符
    BOOL isShopAllSelect = YES;
    for (DWQGoodsModel *model in tempShop.goodsArray) {
        // 当有一个为NO的是时候,将标示符置为NO,并跳出循环
        if (model.select == NO) {
            isShopAllSelect = NO;
            break;
        }
    }
    
    DWQTableHeaderView *header = (DWQTableHeaderView *)[self.myTableView headerViewForSection:section];
    header.select = isShopAllSelect;
    tempShop.select = isShopAllSelect;
}

- (void)verityAllSelectState {
    
    NSInteger count = 0;
    for (DWQShopModel *shop in self.dataArray) {
        count += shop.goodsArray.count;
    }
    
    if (self.selectedArray.count == count) {
        _allSellectedButton.selected = YES;
    } else {
        _allSellectedButton.selected = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
