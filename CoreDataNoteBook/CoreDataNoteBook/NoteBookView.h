//
//  NoteBookView.h
//  SqliteNoteBook
//
//  Created by I三生有幸I on 16/4/4.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteBookView : UIView
@property (nonatomic, retain)UIImageView *headerImageView;
@property(nonatomic, strong)UITextField *titleTextField;
@property(nonatomic, strong)UITextView *contentTextView;

@end
