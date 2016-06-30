//
//  VikingDataManager.m
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//  Copyright © 2016 Space O Technology. All rights reserved.
//
#import "VikingDataManager.h"
@implementation VikingDataManager

@synthesize apiServer;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static VikingDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        apiServer = @"http://thevikingapp.local";
//        NSDictionary *allActivityDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString: activityTypeApiCall]]];
//        //activityCategories = allActivityDict[@"Main_Activities"][@"name"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(UIImage *)loadImageViaApi: (NSString *) entityType : (NSString *) entityId : (NSString*) imageType {
    NSString *imagePath = [NSString stringWithFormat:@"%@/media/%@/%@/%@.png", apiServer, entityType, entityId,imageType];
    NSLog(@"Before call url for: %@",imagePath);
    NSLog(@"This is th crux of where a well-designed image serving api could score major points: %@",imagePath);
    UIImage *intenetActivityImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    NSLog(@"after call url");
    return intenetActivityImage;
}

-(UIImage *)findMainActivityBanner:(NSString *)activityTypeId{
    return [self loadImageViaApi:@"activitytype" :activityTypeId : @"bannerImage"];
}

-(UIImage *)findMainActivityImage:(NSString *)activityTypeId {
    //NSLog(@"just entered loadRemoteImage with imageName : %@",imageName);
    //return [UIImage imageNamed:imageName];
    //http://thevikingapp.local/media/activity/1/backgroundImage3.png
    //http://thevikingapp.local/media/activitytype/1/bannerImage.png
    return [self loadImageViaApi:@"activitytype" :activityTypeId : @"bannerImage"];
}

-(NSArray *)getActivityTypes{
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"main_activities.php"];
    NSDictionary *allActivityDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:activityTypeApiCall]]];
    NSArray *activityTypes = allActivityDict[@"ActivityType"];
    return activityTypes;
}

-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId{
    //http://thevikingapp.local/activities_of_type.php?activityTypeId=3
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@?activityTypeId=%ld", apiServer, @"activities_of_type.php",(long)activityTypeId];
    NSDictionary *allActivityDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:activityTypeApiCall]]];
    NSArray *activities = allActivityDict[@"Activity"];
    return activities;
}

-(NSArray *)getDurationArr{
    NSArray *durations = [NSArray arrayWithObjects: @"1 Day",@"2 Days",@"3+ Days", nil];
    return durations;
}
-(NSArray *)getTemperatureArr{
    NSArray *temperatures = [NSArray arrayWithObjects:
            @"Hot",
            @"Warm",
            @"Cool",
            @"Cold",nil];
    return temperatures;
}

@end