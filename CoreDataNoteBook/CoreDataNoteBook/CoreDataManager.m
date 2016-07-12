//
//  CoreDataManager.m
//  CoreDataNoteBook
//
//  Created by I三生有幸I on 16/4/10.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import "CoreDataManager.h"
#import "NoteBook.h"
@implementation CoreDataManager

// 单例方法
+ (CoreDataManager *)shareIncetance
{
    static CoreDataManager *coreDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[CoreDataManager alloc]init];
    });
    return coreDataManager;
}

// 添加日记的方法
- (void)addNoteWithTableName:(NSString *)tableName noteTitle:(NSString *)noteTitle noteContent:(NSString *)noteContent noteTime:(NSString *)noteTime noteImageData:(NSData *)noteImageData
{
    NoteBook *noteBook = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
    noteBook.noteTitle = noteTitle;
    noteBook.noteContent = noteContent;
    noteBook.noteTime = noteTime;
    noteBook.noteImageData = noteImageData;
    [self saveContext];
}

// 查询所有日记
- (NSArray *)selectAllNoteWithTableName:(NSString *)tableName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:tableName];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:nil];
    return array;
}

// 根据时间删除日记
- (void)deleteNoteWithTableName:(NSString *)tableName forNoteTime:(NSString *)noteTime
{
    // 创建请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:tableName];
    // 创建一个谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteTime = %@", noteTime];
    request.predicate = predicate;
    
    // 根据请求查询结果
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:nil];
    NoteBook *noteBook = array[0];
    [self.managedObjectContext deleteObject:noteBook];
    [self saveContext];
}

// 根据时间修改日记 时间原本的数据就是精确到秒的 所以时间是唯一的
- (void)updateNotoWithTableName:(NSString *)tableName noteTitle:(NSString *)noteTitle noteContent:(NSString *)noteContent noteImageData:(NSData *)noteImageData noteTime:(NSString *)noteTime forNoteTime:(NSString *)forNoteTime
{
    // 修改数据
    // 首先找到想要修改的数据 修改完成之后 同步到数据库
    // 创建一个请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:tableName];
    // 创建一个谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteTime = %@", forNoteTime];
    request.predicate = predicate;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:nil];
    NoteBook *noteBook = array[0];
    noteBook.noteTitle = noteTitle;
    noteBook.noteContent = noteContent;
    noteBook.noteImageData = noteImageData;
    noteBook.noteTime = noteTime;
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.ShengChen.CoreDataNoteBook" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataNoteBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataNoteBookCollectionView.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
