//
//  CoreDataManager.h
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (CoreDataManager *)shareIncetance;

// 添加日记的方法
- (void)addNoteWithTableName:(NSString *)tableName noteTitle:(NSString *)noteTitle noteContent:(NSString *)noteContent noteTime:(NSString *)noteTime noteImageData:(NSData *)noteImageData;

// 查询所有日记
- (NSArray *)selectAllNoteWithTableName:(NSString *)tableName;

// 根据时间删除日记
- (void)deleteNoteWithTableName:(NSString *)tableName forNoteTime:(NSString *)noteTime;

// 根据时间修改日记 时间原本的数据就是精确到秒的 所以时间是唯一的
- (void)updateNotoWithTableName:(NSString *)tableName noteTitle:(NSString *)noteTitle noteContent:(NSString *)noteContent noteImageData:(NSData *)noteImageData noteTime:(NSString *)noteTime forNoteTime:(NSString *)forNoteTime;

@end
