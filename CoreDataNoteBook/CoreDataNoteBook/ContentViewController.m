//
//  ContentViewController.m
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "ContentViewController.h"
#import "NoteBookView.h"
#import "CoreDataManager.h"
@interface ContentViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain)NoteBookView *noteBookView;
@property(nonatomic, retain)UIBarButtonItem *barButton;
// 记录是否是可编辑状态
@property(nonatomic, assign)BOOL isEdit;

@end

@implementation ContentViewController
- (void)dealloc
{
    [_note release];
    [_noteBookView release];
    [_barButton release];
    [super dealloc];
}

#pragma mark --- 将时间转换成字符串 ---
- (NSString *)dateToString
{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY.MM.dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noteBookView = [[NoteBookView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.noteBookView.titleTextField.delegate = self;
    [self.view addSubview:_noteBookView];
    [_noteBookView release];
    
    // 设置交互初始状态
    [self changeState:NO];
    
    self.noteBookView.headerImageView.image = [UIImage imageWithData:self.note.noteImageData];
    self.noteBookView.titleTextField.text = self.note.noteTitle;
    self.noteBookView.contentTextView.text = self.note.noteContent;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.noteBookView.headerImageView addGestureRecognizer:tap];
    [tap release];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
    
    self.barButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.barButton;
    [_barButton release];
}

#pragma mark --- 左边返回按钮触发方法 ---
- (void)leftBarButtonAction:(UIBarButtonItem *)barButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)barButtonAction:(UIBarButtonItem *)button
{
    if (self.isEdit == NO)
    {
        NSLog(@"不可编辑状态变成可编辑状态");
        [self changeState:YES];
        self.barButton.title = @"保存";
    }
    else
    {
        NSLog(@"可编辑状态变成不可编辑状态");
        
        // 标题不能为空
        if (self.noteBookView.titleTextField.text.length == 0)
        {
            [self alertControllerShowWithTitle:nil message:@"日记标题不能为空"];
            return;
        }
        else if (self.noteBookView.contentTextView.text.length == 0)
        {
            [self alertControllerShowWithTitle:nil message:@"日记内容不能为空"];
            return;
        }
        
       // 判断标题重复
       NSArray *array = [[CoreDataManager shareIncetance] selectAllNoteWithTableName:@"NoteBook"];
        for (NoteBook *note in array)
        {
            // 如果不是当前model
            if (![note isEqual:self.note])
            {
                // 和其他model的标题的重复
                if ([note.noteTitle isEqualToString:self.noteBookView.titleTextField.text])
                {
                    [self alertControllerShowWithTitle:nil message:@"和其他记事本标题重复"];
                    return;
                }

            }
        }
        [self changeState:NO];
        self.barButton.title = @"编辑";
        // 更新数据源
        [[CoreDataManager shareIncetance] updateNotoWithTableName:@"NoteBook" noteTitle:self.noteBookView.titleTextField.text noteContent:self.noteBookView.contentTextView.text noteImageData:UIImagePNGRepresentation(self.noteBookView.headerImageView.image) noteTime:[self dateToString] forNoteTime:self.note.noteTime];
    }
    self.isEdit = !self.isEdit;
}

- (void)changeState:(BOOL)state;
{
    for (UIView *view in self.noteBookView.subviews)
    {
        if (![view isKindOfClass:[UITextView class]])
        {
            view.userInteractionEnabled = state;
        }
        else
        {
            UITextView *textView = (UITextView *)view;
            [textView setEditable:state];
        }
    }
}


#pragma mark --- 头像手势触发方法 ---
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // actionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    // 相册按钮
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册");
        
        // 判断有没有相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            // 创建相册对象
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            // 设置调用的是相机还是相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 是否可以编辑
            picker.allowsEditing = YES;
            // 设置代理 代理需要遵守两个协议
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            [picker release];
            
        }
    }];
    [alert addAction:photoAction];
    
    // 相机按钮
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机");
        
    }];
    [alert addAction:cameraAction];
    
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 选择完照片 或者 拍摄完成后 调用的方法 ---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", info);
    // 取到ImageView
    self.noteBookView.headerImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.noteBookView.titleTextField resignFirstResponder];
    [self.noteBookView.contentTextView resignFirstResponder];
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
