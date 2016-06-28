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

@end