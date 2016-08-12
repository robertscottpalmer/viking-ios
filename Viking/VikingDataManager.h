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
#import "AppConstant.h"
@import CoreData;

#ifndef ImageManager_h
#define ImageManager_h

@interface VikingDataManager : NSObject {
}

@property (nonatomic, retain) NSString *apiServer;
@property (nonatomic, retain) NSManagedObjectContext *managedContext;

-(void)showAlert: (NSString *) message;

-(void)setImage: (UIImageView *) targetView : (UIImage *) sourceImage;

/*Activity Type functions*/
-(void)loadMainActivityBanner:(UIImageView *) targetView :(NSString *)activityTypeId;
-(void)loadMainActivityIcon:(UIImageView *) targetView :(NSString *)activityTypeId;
-(void)loadMainActivityBackground:(UIImageView *) targetView :(NSString *)activityTypeId;
-(void)loadMainActivityButton:(UIImageView *) targetView :(NSString *)activityTypeId;
/*Sub activity functions*/
-(void)loadSubActivityIcon:(UIImageView *) targetView :(NSString *)activityId;
-(void)loadSubActivityHorizontalBackground:(UIImageView *)targetView :(NSString *)activityId;
/*Odds and ends*/
-(void)loadDurationIcon:(UIImageView *) targetView :(NSString *)durationId;
-(void)loadTemperatureIcon:(UIImageView *) targetView :(NSString *)temperatureId;

/*Will return an array of dictionaries in the form ({id:"",name:""},{id:"",name:""})*/
-(NSArray *)getActivityTypes;
-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId;
-(NSArray *)getDurationArr;
-(NSArray *)getTemperatureArr;
-(NSArray *)getMainViewMessages;
/*Get individual records*/
-(NSDictionary *)getActivityType:(NSString*)id;
-(NSDictionary *)getActivity:(NSString*)id;
-(NSDictionary *)getDuration:(NSString*)id;
-(NSDictionary *)getTemperature:(NSString*)id;
/*DML operations*/
-(NSString *)createNewTrip: (NSString *)tripName :(NSDictionary *)userSelections;
-(NSArray *)getMyTrips;
-(NSArray *)getGearForTrip:(NSString *)tripId;
-(NSDictionary *)getTrip:(NSString*)tripId;
-(NSDictionary *)getFullTripObject:(NSString*)tripId;
-(CGFloat)getPercentagePacked:(NSString*)tripId;
-(NSString *)getNeighboringTripId: (NSString*)currentId : (BOOL)goBackwards;
-(void)markItemDeleted : (NSString *) itemId : (NSString *) tripId;
-(void)markItemUnpacked : (NSString *) itemId : (NSString *) tripId;
-(void)markItemPacked : (NSString *) itemId : (NSString *) tripId;
-(void)markItemNeeded : (NSString *) itemId : (NSString *) tripId;
+ (id)sharedManager;

@end

#endif /* VikingDataManager_h */
