//
//  VikingDataManager.h
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMLDictionary.h"
#import "ActivityType.h"

#ifndef ImageManager_h
#define ImageManager_h

@interface VikingDataManager : NSObject {
}

@property (nonatomic, retain) NSString *apiServer;

-(UIImage *)findMainActivityImage:(NSString *)activityTypeId;
-(UIImage *)findMainActivityBackground:(NSString *)activityTypeId;
/*Will return an array of dictionaries in the form ({id:"",name:""},{id:"",name:""})*/
-(NSArray *)getActivityTypes;
-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId;
-(NSArray *)getDurationArr;
-(NSArray *)getTemperatureArr;
-(NSArray *)getMainViewMessages;
+ (id)sharedManager;

@end

#endif /* VikingDataManager_h */
