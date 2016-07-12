//
//  NoteBook.h
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteBook : NSManagedObject
@property (nonatomic, assign)BOOL isSelect;

// Insert code here to declare functionality of your managed object subclass
@end

NS_ASSUME_NONNULL_END

#import "NoteBook+CoreDataProperties.h"
