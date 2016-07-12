//
//  RootViewController.m
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "RootViewController.h"
#import "CoreDataManager.h"
#import "NoteBook.h"
#import "DetailViewController.h"
#import "ContentViewController.h"
#import "RootCollectionViewCell.h"
#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KSCreenHeight [[UIScreen mainScreen]bounds].size.height

@interface RootViewController ()  <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)NSMutableArray *modelArray;
@property (nonatomic, retain)UICollectionView *collectionView;
@property (nonatomic, retain)UIBarButtonItem *barButton;
@property (nonatomic, retain)UIView *downView;
@property (nonatomic, retain)UIButton *allSelectCancelButton;
@property (nonatomic, retain)UIButton *delegateButton;
// 记录是否是可编辑状态
@property(nonatomic, assign)BOOL isEdit;

// 记录是否全部选中
@property (nonatomic, assign)BOOL isAllSelect;

@end

@implementation RootViewController
- (void)dealloc
{
    [_collectionView release];
    [_modelArray release];
    [_barButton release];
    [_downView release];
    [_allSelectCancelButton release];
    [_delegateButton release];
    [super dealloc];
}
// 检索数据状态
- (void)coreDataState
{
    // 得到持久化的日记数据
    NSArray *array = [[CoreDataManager shareIncetance]selectAllNoteWithTableName:@"NoteBook"];
    if (array.count == 0)
    {
        NSLog(@"没有日记");
    }
    else
    {
        // 证明有日记 拷贝给表示图数据源数组
        self.modelArray = [NSMutableArray arrayWithArray:array];
        // 按照时间进行排序
        [self.modelArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NoteBook *noteBook1 = (NoteBook *)obj1;
            NoteBook *noteBook2 = (NoteBook *)obj2;
            NSString *dateStr1 = noteBook1.noteTime;
            NSString *dateStr2 = noteBook2.noteTime;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY.MM.dd HH:mm:ss";
            NSDate *date1 = [formatter dateFromString:dateStr1];
            NSDate *date2 = [formatter dateFromString:dateStr2];
            
            NSTimeInterval time = [date1 timeIntervalSinceDate:date2];
            if (time > 0) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
    }
}

// 视图出现时 重新检查数据 并且刷新表视图
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self coreDataState];
    [self.collectionView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"CoreData记事本";
    
    // 添加日记的barButton
    UIBarButtonItem *addLeftBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLeftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = addLeftBarButton;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 375, 667 - 64 - 50) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView release];
    
    // 注册自定义cell类
    [self.collectionView registerClass:[RootCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.barButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.barButton;
    [_barButton release];
    
    
    // 底部的view 装载 全选/取消全选 和 删除的button
    self.downView = [[UIView alloc]initWithFrame:CGRectMake(0, 667 - 64 - 50, 375, 50)];
    self.downView.hidden = YES;
    self.downView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_downView];
    [_downView release];
    
    self.allSelectCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.allSelectCancelButton.frame = CGRectMake(0, 0, 375 / 2, 50);
    [self.allSelectCancelButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.allSelectCancelButton addTarget:self action:@selector(allSelectCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.downView addSubview:_allSelectCancelButton];
    
    self.delegateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.delegateButton.frame = CGRectMake(375 / 2, 0, 375 / 2, 50);
    [self.delegateButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.delegateButton addTarget:self action:@selector(delegateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.downView addSubview:_delegateButton];
    
}

#pragma mark --- 底部的全选/取消全选按钮 ---
- (void)allSelectCancelButtonAction:(UIButton *)button
{
    // 如果是编辑状态下
    if (self.isEdit == YES)
    {
        // 如果没有全部选中 点击 全部选中
        if (self.isAllSelect == NO)
        {
            // 全部置成选中状态
            for (NoteBook *note in self.modelArray)
            {
                note.isSelect = YES;
            }
            // 图片全部变为选中
            for (RootCollectionViewCell *cell in self.collectionView.visibleCells)
            {
                cell.delegateImageView.image = [UIImage imageNamed:@"select.png"];
            }
            [self.allSelectCancelButton setTitle:@"取消全选" forState:UIControlStateNormal];
        }
        // 如果已经全部选中 点击 全部取消
        else
        {
            // 全部置成非选中状态
            for (NoteBook *note in self.modelArray)
            {
                note.isSelect = NO;
            }
            // 图片全部变为取消
            for (RootCollectionViewCell *cell in self.collectionView.visibleCells)
            {
                cell.delegateImageView.image = [UIImage imageNamed:@"cancel.png"];
            }
            [self.allSelectCancelButton setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.isAllSelect = !self.isAllSelect;
    }
}

#pragma mark --- 底部的删除按钮 ---
- (void)delegateButtonAction:(UIButton *)button
{
    NSInteger count = 0;
    for (NSInteger i = self.modelArray.count - 1; i >= 0; i--)
    {
        NoteBook *note = self.modelArray[i];
        if (note.isSelect == YES)
        {
            count = 1;
            // 删除数据源
            [self.modelArray removeObjectAtIndex:i];
            [[CoreDataManager shareIncetance] deleteNoteWithTableName:@"NoteBook" forNoteTime:note.noteTime];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    if (count == 0)
    {
        [self alertControllerShowWithTitle:nil message:@"没有选中任何数据"];
    }
}

// 展示AlertController
- (void)alertControllerShowWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(alertDismiss:) withObject:alert afterDelay:1];
}

// AlertController自动消失
- (void)alertDismiss:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark --- 导航栏的编辑和取消按钮 ---
- (void)barButtonAction:(UIBarButtonItem *)barButton
{
    // 不可编辑状态
    if (self.isEdit == NO)
    {
        NSArray *array = [[CoreDataManager shareIncetance]selectAllNoteWithTableName:@"NoteBook"];
        if (array.count == 0)
        {
            [self alertControllerShowWithTitle:nil message:@"没有添加任何数据"];
            return;
        }
        NSLog(@"不可编辑状态变成可编辑状态");
        [self changeState:NO];
        self.barButton.title = @"取消";
        
        self.downView.hidden = NO;
        

        
    }
    // 可编辑状态
    else
    {
        NSLog(@"可编辑状态变成不可编辑状态");
        [self changeState:YES];
        self.barButton.title = @"编辑";
        
        self.downView.hidden = YES;
        // 全部置成非选中状态
        for (NoteBook *note in self.modelArray)
        {
            note.isSelect = NO;
        }
        for (RootCollectionViewCell *cell in self.collectionView.visibleCells)
        {
            cell.delegateImageView.image = [UIImage imageNamed:@"cancel.png"];
        }
        [self.allSelectCancelButton setTitle:@"全选" forState:UIControlStateNormal];
        self.isAllSelect = NO;

        
    }
    self.isEdit = !self.isEdit;
}

- (void)changeState:(BOOL)state
{
    for (RootCollectionViewCell *cell in self.collectionView.visibleCells)
    {
        cell.delegateImageView.hidden = state;
    }
}

#pragma mark --- 添加事件barButton ---
- (void)addLeftBarButtonAction:(UIBarButtonItem *)barButton
{
    DetailViewController *detailVc = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detailVc animated:YES];
    
    self.isEdit = NO;
    self.barButton.title = @"编辑";
    [self changeState:YES];
    
    self.downView.hidden = YES;
    [self.allSelectCancelButton setTitle:@"全选" forState:UIControlStateNormal];
    self.isAllSelect = NO;
    
    for (NoteBook *note in self.modelArray)
    {
        note.isSelect = NO;
    }
}

#pragma mark --- 返回分区个数 ---
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark --- 返回行数（item个数） ---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

#pragma mark --- 返回cell的方法 ---
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NoteBook *note = self.modelArray[indexPath.row];
    cell.picImageView.image = [UIImage imageWithData:note.noteImageData];
    cell.titleLabel.text = note.noteTitle;
    cell.timeLabel.text = note.noteTime;
    // 如果被选中 是选中状态
    if (note.isSelect == YES)
    {
        cell.delegateImageView.image = [UIImage imageNamed:@"select.png"];
    }
    // 如果没被选中 是非选中状态
    else
    {
        cell.delegateImageView.image = [UIImage imageNamed:@"cancel.png"];
    }
    // 如果是非编辑状态
    if (self.isEdit == NO)
    {
        cell.delegateImageView.hidden = YES;
    }
    // 如果是编辑状态
    else
    {
        cell.delegateImageView.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果是编辑状态 点击控制选中和非选中 不进行跳转
    if (self.isEdit == YES)
    {
        NoteBook *note = self.modelArray[indexPath.row];
        RootCollectionViewCell *cell = (RootCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // 如果没有被选中 再次点击 变为选中状态
        if (note.isSelect == NO)
        {
            cell.delegateImageView.image = [UIImage imageNamed:@"select.png"];
        }
        // 如果被选中 再次点击 变为取消状态
        else
        {
            cell.delegateImageView.image = [UIImage imageNamed:@"cancel.png"];

        }
        note.isSelect = !note.isSelect;
        
        
        // 假设一个没被选中 选中一个加一个 只有count 与 数组个数相同 才是全选状态
        NSInteger count = 0;
        for (NoteBook *note in self.modelArray)
        {
            if (note.isSelect == YES)
            {
                count++;
            }
        }
        // 如果count不等于数组个数 证明 没有都被选中
        if (count != self.modelArray.count)
        {
            [self.allSelectCancelButton setTitle:@"全选" forState:UIControlStateNormal];
            self.isAllSelect = NO;
        }
        // 如果count等于数组个数 证明 已经全部选中
        else
        {
            [self.allSelectCancelButton setTitle:@"取消全选" forState:UIControlStateNormal];
            self.isAllSelect = YES;
        }

        return;
    }
    // 如果是非编辑状态 进行界面跳转
    NoteBook *note = self.modelArray[indexPath.row];
    ContentViewController *contentVc = [[ContentViewController alloc]init];
    contentVc.note = note;
    [self.navigationController pushViewController:contentVc animated:YES];
}

#pragma mark --- 设置item的宽和高 ---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100 + 10 + 30 + 10 + 50);
}

#pragma mark --- 设置整体的上 左 下 右 ---
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
