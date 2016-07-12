//
//  RootCollectionViewCell.m
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/11.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "RootCollectionViewCell.h"

@implementation RootCollectionViewCell

- (void)dealloc
{
    [_timeLabel release];
    [_picImageView release];
    [_titleLabel release];
    [_delegateImageView release];
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.picImageView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_picImageView];
        [_picImageView release];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 100, 30)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 100, 50)];
        self.timeLabel.numberOfLines = 0;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel release];
        
        self.delegateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 0, 30, 30)];
        self.delegateImageView.image = [UIImage imageNamed:@"cancel.png"];
        self.delegateImageView.hidden = YES;
        [self.contentView addSubview:_delegateImageView];
        [_delegateImageView release];

    }
    return self;
}
@end




