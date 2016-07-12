//
//  NoteBookView.m
//  SqliteNoteBook
//
//  Created by I三生有幸I on 16/4/4.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "NoteBookView.h"

@implementation NoteBookView
- (void)dealloc
{
    [_headerImageView release];
    [_titleTextField release];
    [_contentTextView release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 30, 100, 100)];
        self.headerImageView.userInteractionEnabled = YES;
        self.headerImageView.backgroundColor = [UIColor greenColor];
        [self addSubview:_headerImageView];
        [_headerImageView release];
        
        self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 150, 300, 30)];
        self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleTextField.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:_titleTextField];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, 200, 300, 250)];
        [self.contentTextView.layer setCornerRadius:5.0f];
        self.contentTextView.layer.borderWidth = 1;
        self.contentTextView.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentTextView.backgroundColor = [UIColor whiteColor];
        self.contentTextView.keyboardType = UIKeyboardTypeDefault;
        self.contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:_contentTextView];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
