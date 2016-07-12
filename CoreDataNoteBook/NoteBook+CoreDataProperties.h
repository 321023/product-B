//
//  NoteBook+CoreDataProperties.h
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *noteTitle;
@property (nullable, nonatomic, retain) NSString *noteContent;
@property (nullable, nonatomic, retain) NSString *noteTime;
@property (nullable, nonatomic, retain) NSData *noteImageData;

@end

NS_ASSUME_NONNULL_END
