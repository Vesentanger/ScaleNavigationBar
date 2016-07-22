//
//  ViewController.m
//  ESNavigationController
//
//  Created by 梅守强 on 16/7/21.
//  Copyright © 2016年 eshine. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define IMAGEVIEW_HEIGHT (220)
#define NavigationBar_HEIGHT (64)
#define RandomColor ([UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0])

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 解决视图下移
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 给tableView加一个tableHeaderView
    [self addTableHeaderView];
    // 隐藏push进来的navigationBar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 新建一个自定义的navigationBar
    [self addCustomNavigationBar];
    // 注册tableViewCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
}

- (void)addTableHeaderView {
    _headerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header"]];
    _headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IMAGEVIEW_HEIGHT);
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGEVIEW_HEIGHT)];
    [_headerView addSubview:_headerImageView];
    self.tableView.tableHeaderView = _headerView;
}

- (void)addCustomNavigationBar {
    _navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    _navigationBar.translucent = NO;
    _navigationBar.tintColor = [UIColor whiteColor];
    
    // 自定义UINavigationBar,将私有类_UINavigationBarBackground从navigationBar中删除
    for (UIView *view in _navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:_navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"title"];
    UINavigationItem *item = [[UINavigationItem alloc]init];
    item.titleView = titleLabel;
    
    item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    _navigationBar.items = @[item];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

#pragma mark - UITableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    // headerView的缩放
    CGFloat scale = 1.0;
    // 放大
    if (offsetY < 0) {
        // 允许下拉放大的最大距离为300
        // 1.5是放大的最大倍数
        // 这个值可以自由调整
        scale = MIN(1.5, 1 - offsetY / 300);
    } else if (offsetY > 0) { // 缩小
        // 允许向上超过导航条缩小的最大距离为300
        // 1.0是缩小的最小倍数(此处不缩小)
        scale = MAX(1.0, 1 - offsetY / 300);
    }
    _headerImageView.transform = CGAffineTransformMakeScale(scale, scale);
    // 保证缩放后y坐标不变
    CGRect frame = _headerImageView.frame;
    frame.origin.y = -_headerImageView.layer.cornerRadius / 2;
    _headerImageView.frame = frame;
    
    // 导航条的渐隐
    UIColor *color = RandomColor;
    offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((64 - offsetY) / 64);
        _navigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        _navigationBar.backgroundColor = [color colorWithAlphaComponent:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
