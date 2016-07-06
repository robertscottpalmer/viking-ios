//
//  VikingDataManager.m
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//  Copyright © 2016 Space O Technology. All rights reserved.
//
#import "VikingDataManager.h"
@implementation VikingDataManager

@synthesize apiServer,managedContext;

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
        id delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate performSelector:@selector(managedObjectContext)]) {
            managedContext = [delegate managedObjectContext];
        }
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

-(UIImage *)findMainActivityIcon:(NSString *)activityTypeId {
    //NSLog(@"just entered loadRemoteImage with imageName : %@",imageName);
    //return [UIImage imageNamed:imageName];
    //http://thevikingapp.local/media/activity/1/backgroundImage3.png
    //http://thevikingapp.local/media/activitytype/1/bannerImage.png
    return [self loadImageViaApi:@"activitytype" :activityTypeId : @"buttonIcon"];
}

-(UIImage *)findMainActivityBackground:(NSString *)activityTypeId {
    //NSLog(@"just entered loadRemoteImage with imageName : %@",imageName);
    //return [UIImage imageNamed:imageName];
    //http://thevikingapp.local/media/activity/1/backgroundImage3.png
    //http://thevikingapp.local/media/activitytype/1/bannerImage.png
    return [self loadImageViaApi:@"activitytype" :activityTypeId : @"backgroundImage"];
}

-(UIImage *)findMainActivityButton:(NSString *)activityTypeId{
    return [self loadImageViaApi:@"activitytype" :activityTypeId : @"buttonBackground"];
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
    NSArray *durations = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"1 Day",@"description",@"Raid",@"name",@"1",@"id",nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"2 Days",@"description",@"Journey",@"name",@"2", @"id", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"3+ Days",@"description",@"Expedition",@"name",@"3", @"id", nil], nil];
    return durations;
}
-(NSArray *)getTemperatureArr{
    NSArray *temperatures = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"Hot",@"name",@"1",@"id",nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"Warm",@"name",@"2", @"id", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"Cool",@"name",@"3", @"id", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"Cold",@"name",@"4", @"id", nil], nil];
    return temperatures;
}

-(NSArray *)getMainViewMessages{
    NSArray *messages = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObject:@"This is a fun message that did not come from facebook!" forKey:@"message"],
                             [NSDictionary dictionaryWithObject:@"2This is a fun message that did not come from facebook!" forKey:@"message"],
                             [NSDictionary dictionaryWithObject:@"3This is a fun message that did not come from facebook!" forKey:@"4message"],
                             [NSDictionary dictionaryWithObject:@"5This is a fun message that did not come from facebook!" forKey:@"message"],
                             nil];
    NSLog(@"messages are %@",messages);
    return messages;
}

-(NSString *)createNewTrip: (NSDictionary *)userSelections{
    
    NSManagedObject *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"MyActivityList" inManagedObjectContext:managedContext];
    
    NSString *warningMessage = [NSString stringWithFormat:@"Let's put some thought into how we store trips, userSelections=%@",userSelections];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:warningMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
//    [newActivity setValue:activityName forKey:@"activityList_Name"];
//    [newActivity setValue:self.durationDict[@"title"] forKey:@"duration"];
//    [newActivity setValue:selectedActivityTypeId forKey:@"main_Activity"];
//    //NOTE: this should not be hard-coded
//    [newActivity setValue:self.activityDict[@"title"][@"1"] forKey:@"sub_activity"];
//    [newActivity setValue:self.tempDict[@"title"] forKey:@"temperature"];
//    
//    NSError *error = nil;
//    // Save the object to persistent store
//    if (![context save:&error]) {
//        //        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//    }
//    
//    
//    for(NSDictionary *equipmentDict in list)
//    {
//        NSManagedObject *newActivityList = [NSEntityDescription insertNewObjectForEntityForName:@"MyActivityEquipmentList" inManagedObjectContext:context];
//        [newActivityList setValue:activityName forKey:@"activityList_Name"];
//        [newActivityList setValue:self.durationDict[@"title"] forKey:@"duration"];
//        //        [newActivityList setValue:selectedActivity forKey:@"main_Activity"];
//        [newActivityList setValue:self.activityDict[@"title"] forKey:@"sub_activity"];
//        [newActivityList setValue:self.tempDict[@"title"] forKey:@"temperature"];
//        [newActivityList setValue:equipmentDict[@"name"] forKey:@"equipment"];
//        [newActivityList setValue:@"hexa_orange" forKey:@"image"];
//        
//        NSError *error1 = nil;
//        // Save the object to persistent store
//        if (![context save:&error1]) {
//            NSLog(@"Can't Save! %@ %@", error1, [error1 localizedDescription]);
//        }
//    }
//    
//    //    [self fetchdata];
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    
//    [dict setValue:self.activityDict[@"image"] forKey:@"ActivityImage"];
//    [dict setValue:self.activityDict[@"title"] forKey:@"ActivityTitle"];
//    [dict setValue:self.durationDict[@"image"] forKey:@"DurationImage"];
//    [dict setValue:self.durationDict[@"title"] forKey:@"DurationTitle"];
//    [dict setValue:self.tempDict[@"image"] forKey:@"TempImage"];
//    [dict setValue:self.tempDict[@"title"] forKey:@"TempTitle"];
//    [dict setValue:self.activityNameTxt.text forKey:@"activityListname"];
//    //    [dict setValue:selectedActivity forKey:@"main_Activity"];
    return @"Woot!!";
    
}

@end