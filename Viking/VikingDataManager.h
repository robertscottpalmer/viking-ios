//
//  VikingDataManager.h
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSExtensionRequestHandling.h>
#import <UIKit/UIKit.h>
#import "XMLDictionary.h"
@import CoreData;

#ifndef ImageManager_h
#define ImageManager_h

@interface VikingDataManager : NSObject {
}

@property (nonatomic, retain) NSString *apiServer;
@property (nonatomic, retain) NSManagedObjectContext *managedContext;

-(UIImage *)findMainActivityBanner:(NSString *)activityTypeId;
-(UIImage *)findMainActivityIcon:(NSString *)activityTypeId;
-(UIImage *)findMainActivityBackground:(NSString *)activityTypeId;
-(UIImage *)findMainActivityButton:(NSString *)activityTypeId;
/*Will return an array of dictionaries in the form ({id:"",name:""},{id:"",name:""})*/
-(NSArray *)getActivityTypes;
-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId;
-(NSArray *)getDurationArr;
-(NSArray *)getTemperatureArr;
-(NSArray *)getMainViewMessages;
//-(NSString *)createNewTrip: (NSInteger)activityId : (NSString *) durationId : (NSString *) temperatureId;
-(NSString *)createNewTrip: (NSDictionary *)userSelections;
+ (id)sharedManager;

@end

#endif /* VikingDataManager_h */
