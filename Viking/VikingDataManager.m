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

-(void)setImage: (UIImageView *) targetView : (UIImage *) sourceImage {
    NSLog(@"trying to overwrite %@ with %@",targetView,sourceImage);
    targetView.image = sourceImage;
}

-(void)loadImageViaApi: (UIImageView *) targetView : (NSString *) entityType : (NSString *) entityId : (NSString*) imageType {
    targetView.image = [UIImage imageNamed:@"loading"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        // Perform async operation
        NSString *imagePath = [NSString stringWithFormat:@"%@/media/%@/%@/%@.png", apiServer, entityType, entityId,imageType];
        //NSLog(@"Before call url for: %@",imagePath);
        //NSLog(@"This is th crux of where a well-designed image serving api could score major points: %@",imagePath);
        UIImage *internetActivityImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        //NSLog(@"after call url");
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Update UI
            if (internetActivityImage != nil){
                targetView.image = internetActivityImage;
            }else{
                targetView.image = [UIImage imageNamed:@"ImageUnavailable"];
            }
        });
    });
    
}

-(void)loadMainActivityBanner: (UIImageView *) targetView :(NSString *)activityTypeId{
    [self loadImageViaApi:targetView:@"activitytype" :activityTypeId : @"bannerImage"];
}

-(void)loadMainActivityIcon: (UIImageView *) targetView :(NSString *)activityTypeId {
    [self loadImageViaApi:targetView:@"activitytype" :activityTypeId : @"buttonIcon"];
}

-(void)loadMainActivityBackground:(UIImageView *) targetView :(NSString *)activityTypeId {
    [self loadImageViaApi:targetView:@"activitytype" :activityTypeId : @"backgroundImage"];
}

-(void)loadMainActivityButton:(UIImageView *) targetView :(NSString *)activityTypeId{
    [self loadImageViaApi:targetView:@"activitytype" :activityTypeId : @"buttonBackground"];
}

-(void)loadSubActivityIcon:(UIImageView *) targetView :(NSString *)activityId{
    [self loadImageViaApi:targetView :@"activity" :activityId : @"buttonIcon"];
}

-(void)loadSubActivityHorizontalBackground:(UIImageView *)targetView :(NSString *)activityId;
{
    [self loadImageViaApi:targetView :@"activity" :activityId : @"horizontalBackground"];
}

-(void)loadDurationIcon:(UIImageView *) targetView :(NSString *)durationId{
    [self loadImageViaApi:targetView :@"duration" :durationId : @"buttonIcon"];
}

-(void)loadTemperatureIcon:(UIImageView *) targetView :(NSString *)temperatureId{
    [self loadImageViaApi:targetView :@"temperature" :temperatureId : @"buttonIcon"];
}

/**From here down are true data management tasks**/

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
    NSString *announcementsApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"announcements.php"];
    NSDictionary *announcementDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:announcementsApiCall]]];
    return announcementDict[@"Announcement"];
    
//    NSArray *messages = [NSArray arrayWithObjects:
//                             [NSDictionary dictionaryWithObject:@"This is a fun message that did not come from facebook!" forKey:@"message"],
//                             [NSDictionary dictionaryWithObject:@"2This is a fun message that did not come from facebook!" forKey:@"message"],
//                             [NSDictionary dictionaryWithObject:@"3This is a fun message that did not come from facebook!" forKey:@"4message"],
//                             [NSDictionary dictionaryWithObject:@"5This is a fun message that did not come from facebook!" forKey:@"message"],
//                             nil];
//    NSLog(@"messages are %@",messages);
//    return messages;
}

-(NSDictionary *)getSingleApiObject:(NSString*) entityType :(NSString*)id{
    ///entityById.php?entityType=activity&entityId=1
    //http://thevikingapp.local/activities_of_type.php?activityTypeId=3
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@?entityType=%@&entityId=%@", apiServer, @"entityById.php",entityType,id];
    NSLog(@"Calling API : %@",activityTypeApiCall);
    NSDictionary *objectDict = [NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:activityTypeApiCall]]];
    NSDictionary *requestedObject = objectDict[@"Entity"];
    return requestedObject;
}

-(NSDictionary *)getActivityType:(NSString*)id{
    return [self getSingleApiObject:@"activityType" :id];
}
-(NSDictionary *)getActivity:(NSString*)id{
    return [self getSingleApiObject:@"activity" :id];
}
-(NSDictionary *)getDuration:(NSString*)id{
    return [self getSingleApiObject:@"duration" :id];
}
-(NSDictionary *)getTemperature:(NSString*)id{
    return [self getSingleApiObject:@"temperature" :id];
}

//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *managedcontext = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        managedcontext = [delegate managedObjectContext];
//    }
//    return managedcontext;
//}

/*Creates a new trip, persists the data and returns the id of the newly created trip.*/
-(NSString *)createNewTrip: (NSString *)tripName : (NSDictionary *)userSelections{
    NSManagedObject *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:managedContext];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [newActivity setValue:uuid forKey:@"id"];
    [newActivity setValue:tripName forKey:@"name"];
    [newActivity setValue:userSelections[USER_SELECTED_ACTIVITY][@"id"] forKey:@"activityId"];
    [newActivity setValue:userSelections[USER_SELECTED_DURATION][@"id"] forKey:@"durationId"];
    [newActivity setValue:userSelections[USER_SELECTED_TEMPERATURE][@"id"] forKey:@"temperatureId"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![managedContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
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
    return uuid;
    
}

-(NSArray *)getMyTrips{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.returnsObjectsAsFaults = NO;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedContext];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
        
        NSLog(@"array - %@", fetchedObjects);
    return fetchedObjects;
}

-(NSDictionary *)getTrip:(NSString*)id{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    //now limit the result set to our id.
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"id=%@", id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"array - %@", fetchedObjects);
    NSManagedObject *storedTrip = fetchedObjects[0];
    NSMutableDictionary *toReturn = [[NSMutableDictionary alloc] init];
    toReturn[@"id"] = [storedTrip valueForKey:@"id"];
    toReturn[@"name"] = [storedTrip valueForKey:@"name"];
    toReturn[@"activityId"] = [storedTrip valueForKey:@"activityId"];
    toReturn[@"durationId"] = [storedTrip valueForKey:@"durationId"];
    toReturn[@"temperatureId"] = [storedTrip valueForKey:@"temperatureId"];
    return toReturn;
}

@end