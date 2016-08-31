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
        //apiServer = @"http://thevikingapp.local";
        apiServer = @"http://thevikingapp.com/api";
        id delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate performSelector:@selector(managedObjectContext)]) {
            managedContext = [delegate managedObjectContext];
        }
    }
    return self;
}

// Checks if we have an internet connection or not
- (BOOL)hazInternetConnection
{
    internetReachability = [Reachability reachabilityWithHostName:apiServer];
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    return internetStatus != NotReachable;
}


- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(NSString *)getUrlToOpen:(NSDictionary *) postRecord{
    if(postRecord[@"target_url"] != nil && [postRecord[@"target_url"] length] > 0){
        return postRecord[@"target_url"];
    }else{
        return [NSString stringWithFormat:@"%@/public_announcements.php#announcement_%@",apiServer,postRecord[@"id"]];
    }
}

-(void)showAlert: (NSString *) message {
    NSLog(@"message = %@",message);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DataMangerAlert" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    [alertView show];
}

-(void)setImage: (UIImageView *) targetView : (UIImage *) sourceImage {
    //NSLog(@"trying to overwrite %@ with %@",targetView,sourceImage);
    targetView.image = sourceImage;
}

-(void)loadImageViaApi: (UIImageView *) targetView : (NSString *) entityType : (NSString *) entityId : (NSString*) imageType {
    targetView.image = [UIImage imageNamed:@"loading"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        // Perform async operation
        NSString *imagePath = [NSString stringWithFormat:@"%@/media/%@/%@/%@.png", apiServer, entityType, entityId,imageType];
        //NSLog(@"trying to retrieve %@",imagePath);
        UIImage *internetActivityImage = [UIImage imageWithData:[self attemptCacheRetrieve:[NSURL URLWithString:imagePath]]];
        dispatch_async(dispatch_get_main_queue(), ^{
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

-(void)saveContext{
    NSError *error = nil;
    if (![managedContext save:&error]){
        //[self showAlert:[NSString stringWithFormat:@"Can't Save! %@ %@", error, [error localizedDescription]]];
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

-(NSDictionary *)getPotentiallyCachedDictionary:(NSString *) apiCall{
    NSData *potentiallyCachedData = [self attemptCacheRetrieve:[NSURL URLWithString:apiCall]];
    return [NSDictionary dictionaryWithXMLData:potentiallyCachedData];
}

-(NSArray *)getActivityTypes{
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"main_activities.php"];
    NSDictionary *allActivityDict = [self getPotentiallyCachedDictionary:activityTypeApiCall];
    NSArray *activityTypes = allActivityDict[@"ActivityType"];
    return activityTypes;
}

-(NSArray *)getActivitiesOfType:(NSInteger)activityTypeId{
    NSString *activityTypeApiCall = [NSString stringWithFormat:@"%@/%@?activityTypeId=%ld", apiServer, @"activities_of_type.php",(long)activityTypeId];
    NSDictionary *allActivityDict = [self getPotentiallyCachedDictionary:activityTypeApiCall];
    NSArray *activities = allActivityDict[@"Activity"];
    return activities;
}

-(NSArray *)getDurationArr{
    NSString *durationApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"durations.php"];
    //NSData *potentiallyCachedData = [self attemptCacheRetrieve:[NSURL URLWithString:durationApiCall]];
    NSDictionary *allDurationDict = [self getPotentiallyCachedDictionary:durationApiCall];
    NSArray *durations = allDurationDict[@"Duration"];
    return durations;
}
-(NSArray *)getTemperatureArr{
    NSString *temperatureApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"temperatures.php"];
    //NSData *potentiallyCachedData = [self attemptCacheRetrieve:[NSURL URLWithString:temperatureApiCall]];
    NSDictionary *allTemperatureDict = [self getPotentiallyCachedDictionary:temperatureApiCall];
    NSArray *temperatures = allTemperatureDict[@"Temperature"];
    return temperatures;
}

-(NSArray *)getMainViewMessages{
    NSString *announcementsApiCall = [NSString stringWithFormat:@"%@/%@", apiServer, @"announcements.php"];
   // NSData *potentiallyCachedData = [self attemptCacheRetrieve:[NSURL URLWithString:announcementsApiCall]];
    NSDictionary *announcementDict = [self getPotentiallyCachedDictionary:announcementsApiCall];//[NSDictionary dictionaryWithXMLData:potentiallyCachedData];
    return announcementDict[@"Announcement"];
}

-(NSDictionary *)getSingleApiObject:(NSString*) entityType :(NSString*)id{
    NSString *singleEntityApiCall = [NSString stringWithFormat:@"%@/%@?entityType=%@&entityId=%@", apiServer, @"entityById.php",entityType,id];
    //NSLog(@"Calling API : %@",activityTypeApiCall);
    //NSData *potentiallyCachedData = [self attemptCacheRetrieve:[NSURL URLWithString:activityTypeApiCall]];
    NSDictionary *objectDict = [self getPotentiallyCachedDictionary:singleEntityApiCall];
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

/*Creates a new trip, persists the data and returns the id of the newly created trip.*/
-(NSString *)createNewTrip: (NSString *)tripName : (NSDictionary *)userSelections{
    NSManagedObject *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:managedContext];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [newActivity setValue:uuid forKey:@"id"];
    [newActivity setValue:tripName forKey:@"name"];
    [newActivity setValue:userSelections[USER_SELECTED_ACTIVITY][@"id"] forKey:@"activityId"];
    [newActivity setValue:userSelections[USER_SELECTED_DURATION][@"id"] forKey:@"durationId"];
    [newActivity setValue:userSelections[USER_SELECTED_TEMPERATURE][@"id"] forKey:@"temperatureId"];
    [self saveContext];
    return uuid;
    
}

-(void)resetListForTrip: (NSString *)tripId{
    //[self showAlert:[NSString stringWithFormat:@"Only partially implemented refreshing view is not working!"]];
    NSArray *gearList = [self getGearForTrip:tripId];
    for (int gearListIdx = 0; gearListIdx < [gearList count]; gearListIdx++) {
        NSDictionary *gear = gearList[gearListIdx];
        [self markItemUnpacked:gear[@"id"]:tripId];
    }
    [self saveContext];
}

-(void)deleteListForTrip: (NSString *)tripId{
    NSManagedObject *tripObj = [self getManagedTripObject:tripId];
    if (tripObj != nil){
        [managedContext deleteObject:tripObj];
        [self saveContext];
    }
}

-(void)renameTrip: (NSString *)tripId :(NSString *)newTripName{
    NSManagedObject *tripObj = [self getManagedTripObject:tripId];
    if (tripObj != nil){
        [tripObj setValue:newTripName forKey:@"name"];
        [self saveContext];
    }
}

-(void)addCustomItemToTripList: (NSString *)tripId :(NSString *)customItemName{
    [self showAlert:[NSString stringWithFormat:@"NOT YET IMPLEMENTED ! Need to add a custom item to trip id = %@ with custom item name = %@",tripId,customItemName]];
}

-(NSArray *)getMyTrips{
    NSArray *fetchedObjects = [self fetchManagedObjects:@"Trip" :nil];
    return fetchedObjects;
}

-(NSArray *)getGearForTrip:(NSString *)tripId{
    ///entities you will need to deal with are : GearRecommendation, TripGear
    NSDictionary *trip = [self getTrip:tripId];
    NSString *gearForTripApiCall = [NSString stringWithFormat:@"%@/%@?activityId=%@&temperatureId=%@&durationId=%@", apiServer, @"gearlist.php",trip[@"activityId"],trip[@"temperatureId"],trip[@"durationId"]];
    NSDictionary *tripGearDict = [self getPotentiallyCachedDictionary:gearForTripApiCall];//[NSDictionary dictionaryWithXMLData:[NSData dataWithContentsOfURL: [NSURL URLWithString:gearForTripApiCall]]];
    NSArray *gearList = tripGearDict[@"Gear"];
    //Loop through gear list and add gear state to the mix
    
    for (int gearListIdx = 0; gearListIdx < [gearList count]; gearListIdx++) {
        id gearRecommendation = [gearList objectAtIndex:gearListIdx];
        NSString *gearRecommendationId = [gearRecommendation valueForKey:@"id"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gearRecommendationId=%@", gearRecommendationId];
        NSArray *gearStates = [self fetchManagedObjects:@"TripGear" :predicate];
        if (gearStates != nil && [gearStates count] > 0){
            [gearRecommendation setValue:[gearStates[0] valueForKey:@"tripGearStatus"] forKey:@"tripGearStatus"];
        }else{
            [gearRecommendation setValue:ITEM_STATE_UNPACKED forKey:@"tripGearStatus"];
        }
    }
    return gearList;
}

-(NSArray *)fetchManagedObjects:(NSString *) entityForName : (NSPredicate *) predicate{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityForName inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    if (predicate != nil){
        [fetchRequest setPredicate:predicate];
    }
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}
     
-(NSManagedObject *)getManagedTripObject:(NSString*)tripId{
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"id=%@", tripId];
    NSArray *fetchedObjects = [self fetchManagedObjects:@"Trip" :predicate];
    return fetchedObjects[0];
}

-(NSDictionary *)getTrip:(NSString*)tripId{
    //now limit the result set to our id.
    NSManagedObject *storedTrip = [self getManagedTripObject:tripId];
    NSMutableDictionary *toReturn = [[NSMutableDictionary alloc] init];
    toReturn[@"id"] = [storedTrip valueForKey:@"id"];
    toReturn[@"name"] = [storedTrip valueForKey:@"name"];
    toReturn[@"activityId"] = [storedTrip valueForKey:@"activityId"];
    toReturn[@"durationId"] = [storedTrip valueForKey:@"durationId"];
    toReturn[@"temperatureId"] = [storedTrip valueForKey:@"temperatureId"];
    return toReturn;
}

-(NSDictionary *)getFullTripObject:(NSString*)tripId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    
    //now limit the result set to our id.
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"id=%@", tripId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"array - %@", fetchedObjects);
    NSManagedObject *storedTrip = fetchedObjects[0];
    NSMutableDictionary *toReturn = [[NSMutableDictionary alloc] init];
    toReturn[@"id"] = [storedTrip valueForKey:@"id"];
    toReturn[@"name"] = [storedTrip valueForKey:@"name"];
    toReturn[@"activity"] = [self getActivity:[storedTrip valueForKey:@"activityId"]];
    toReturn[@"duration"] = [self getDuration:[storedTrip valueForKey:@"durationId"]];
    toReturn[@"temperature"] = [self getTemperature:[storedTrip valueForKey:@"temperatureId"]];
    return toReturn;
}

-(NSString *)getNeighboringTripId: (NSString*)currentId : (BOOL) goBackwards{
    NSLog(@"here I am in a poor implementation of going forwards or backwards");
    NSArray *trips = [self getMyTrips];
    int foundAt;
    for (foundAt = 0; foundAt < [trips count]; foundAt++) {
        id trip = [trips objectAtIndex:foundAt];
        NSString *tripId = [trip valueForKey:@"id"];
        if ([tripId isEqualToString:currentId]){
            break;
        }
    }
    //figure out which object is our target
    if (goBackwards){
        if (foundAt == 0){
            foundAt = (int)([trips count] - 1);
        }
    }else{
        foundAt++;
        if (foundAt >= [trips count]){
            foundAt = 0;
        }
    }
    NSManagedObject *targetTrip = [trips objectAtIndex:foundAt];
    return [targetTrip valueForKey:@"id"];
}

-(CGFloat)getPercentagePacked:(NSString*)tripId{
    NSArray *allGear = [self getGearForTrip:tripId];
    int currentIdx = 0;
    int packedCount = 0;
    int explicitlyExcludedCount = 0;
    for (currentIdx = 0; currentIdx < [allGear count]; currentIdx++) {
        id gearStatus = [allGear objectAtIndex:currentIdx];
        if ([[gearStatus valueForKey:@"tripGearStatus"] isEqualToString:ITEM_STATE_PACKED]){
            packedCount++;
        }else if ([[gearStatus valueForKey:@"tripGearStatus"] isEqualToString:ITEM_STATE_EXPLICIT_DELETE]){
            explicitlyExcludedCount++;
        }
    }
    //TODO: there should be no need to explicitly convert every argument to a CGFloat, get efficient.
    CGFloat retVal = ((CGFloat)packedCount)/(CGFloat)(currentIdx - explicitlyExcludedCount) ;
    return retVal;
}



//It should be noted here that the "itemId" is actually assumed to be the id of the gearRecommendaton
-(void)markItemState: (NSString*) itemState : (NSString *) gearRecommendationId : (NSString *) tripId{
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"gearRecommendationId = %@", gearRecommendationId];
    NSArray *fetchedObjects = [self fetchManagedObjects:@"TripGear" :predicate];
    NSManagedObject *listStatus = nil;
    if ([fetchedObjects count] == 0){
        listStatus = [NSEntityDescription insertNewObjectForEntityForName:@"TripGear" inManagedObjectContext:managedContext];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [listStatus setValue:uuid forKey:@"id"];
        [listStatus setValue:gearRecommendationId forKey:@"gearRecommendationId"];
    }else{
        listStatus = fetchedObjects[0];
    }
    [listStatus setValue:itemState forKey:@"tripGearStatus"];
    [self saveContext];
    }
-(void)markItemDeleted: (NSString *) itemId : (NSString*) tripId{
    [self markItemState:ITEM_STATE_EXPLICIT_DELETE :itemId :tripId];
}
-(void)markItemUnpacked: (NSString *) itemId : (NSString*) tripId{
    [self markItemState:ITEM_STATE_UNPACKED :itemId :tripId];
}
-(void)markItemPacked: (NSString *) itemId : (NSString*) tripId{
    [self markItemState:ITEM_STATE_PACKED :itemId :tripId];
}
-(void)markItemNeeded: (NSString *) itemId : (NSString*) tripId{
    [self markItemState:ITEM_STATE_NEEDED :itemId :tripId];
}


-(NSData *)attemptCacheRetrieve: (NSURL *) urlToCheck{
    NSString *base64EncodedUrl = [[urlToCheck dataRepresentation] base64EncodedStringWithOptions:0];
    NSString *tmpCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                          NSUserDomainMask,
                                                          YES) lastObject];
    NSString *cacheFileName = [NSString stringWithFormat:@"%@/%@",tmpCachePath,base64EncodedUrl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSLog(@"Checking internet connectivity");
    BOOL hazInternets = true;//[self hazInternetConnection];
    //NSLog(@"Done Checking internet connectivity");
    NSData *freshData = nil;
    if ([fileManager fileExistsAtPath:cacheFileName]){
        //NSLog(@"The file exists, no need to hit the internet");
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:cacheFileName error:nil];
        NSDate *cachedDate = fileAttributes[@"NSFileCreationDate"];
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:cachedDate];
        if (today){
            return [fileManager contentsAtPath:cacheFileName];
        }else if (hazInternets){
            freshData = [fileManager contentsAtPath:cacheFileName];
        }
    }
    //nothing was cached within the last day, so we will check the internet (if possible).
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"vikingapplication", @"wg<kQ2j2{,Qw"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    
    //Set up Request:
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:urlToCheck];
    //...
    // Pack in the user credentials
    [request setValue:[NSString stringWithFormat:@"%@",authValue] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod: @"GET"];
    
    //send the request and use the response
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    if (hazInternets){
        freshData =
        [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    }
    
    //freshData = hazInternets ? [NSData dataWithContentsOfURL:urlToCheck] : freshData;
    
    if (requestError != nil){
        NSLog(@"There were issues encountered while trying to use the internet. Viking data may not be up to date.");
    }
    
    if (requestError == nil && freshData != nil){
        //store the data to cache in background so as to not hold up ui rendering
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [freshData writeToFile:cacheFileName atomically:true];
        });
    }
    return freshData;
}



@end