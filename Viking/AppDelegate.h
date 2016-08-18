//
//  AppDelegate.h
//  Viking
//
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppConstant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, strong) NSMutableDictionary *activityDict;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//+(MBProgressHUD *)showGlobalProgressHudwithTitle:(NSString *)title;
//+(void)hideGlobalHUD;



@end

