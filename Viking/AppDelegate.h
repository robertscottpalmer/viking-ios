//
//  AppDelegate.h
//  Viking
//
//  Created by macmini08 on 27/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "AppConstant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, strong) NSMutableDictionary *activityDict;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(MBProgressHUD *)showGlobalProgressHudwithTitle:(NSString *)title;
+(void)hideGlobalHUD;



@end

