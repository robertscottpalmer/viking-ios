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

-(UIImage *)findMainActivityImage:(NSString *)activityId {
    //NSLog(@"just entered loadRemoteImage with imageName : %@",imageName);
    //return [UIImage imageNamed:imageName];
    //http://thevikingapp.local/media/activity/1/backgroundImage3.png
    //http://thevikingapp.local/media/activitytype/1/bannerImage.png
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@%@", apiServer, @"fetchpng.php?activityName=", activityId];
    //imagePath = @"http://robertscottpalmer.com/viking/images/Water@2x.png";
    NSLog(@"Before call url for: %@",imagePath);
    UIImage *intenetActivityImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    NSLog(@"after call url");
    return intenetActivityImage;
}

-(NSArray *)getActivityTypes{
    NSLog(@"Here!!!");
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"main_activities.php"];
    NSDictionary *allActivityDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:activityTypeApiCall]]];
    NSArray *activityTypes = allActivityDict[@"ActivityType"];
    return activityTypes;
}

-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId{
    NSMutableArray *dummyArray = [NSMutableArray array];
    for (int i = 0; i < activityTypeId; i++) {
        [dummyArray addObject:[[NSString alloc] init]];
    }
    NSArray *activitiesOfType = [NSArray arrayWithArray:dummyArray]; // if you want immutable array
    return activitiesOfType;
}

@end