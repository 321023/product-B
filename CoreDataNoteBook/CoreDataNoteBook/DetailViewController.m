//
//  DetailViewController.m
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteBookView.h"
#import "CoreDataManager.h"
#import "NoteBook.h"
@interface DetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain)NoteBookView *noteBookView;

@end

@implementation DetailViewController
- (void)dealloc
{
    [_noteBookView release];
    [super dealloc];
}

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
    
    UIBarButtonItem *saveRightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveRightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = saveRightBarButton;
    
    self.noteBookView = [[NoteBookView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.noteBookView.titleTextField.delegate = self;
    [self.view addSubview:_noteBookView];
    [_noteBookView release];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.noteBookView.headerImageView addGestureRecognizer:tap];
    [tap release];

}

#pragma mark --- 保存日记的触发方法 ---
- (void)saveRightBarButtonAction:(UIBarButtonItem *)barButton
{
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
    // 检索数据 看日记标题是否与之前有重复
    NSArray *array = [[CoreDataManager shareIncetance] selectAllNoteWithTableName:@"NoteBook"];
    if (array.count > 0)
    {
        for (NoteBook *note in array)
        {
            if ([note.noteTitle isEqualToString:self.noteBookView.titleTextField.text])
            {
                [self alertControllerShowWithTitle:nil message:@"日记标题与之前有重复"];
                return;
            }
        }
    }
    else
    {
        NSLog(@"还没有添加过日记");
    }
    
    // 真正添加日记
    // 传入日记标题 日记内容 日记时间 日记头像
    [[CoreDataManager shareIncetance] addNoteWithTableName:@"NoteBook" noteTitle:self.noteBookView.titleTextField.text noteContent:self.noteBookView.contentTextView.text noteTime:[self dateToString] noteImageData:UIImagePNGRepresentation(self.noteBookView.headerImageView.image)];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
