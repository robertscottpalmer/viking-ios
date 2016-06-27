//
//  VikingDataManager.m
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//  Copyright © 2016 Space O Technology. All rights reserved.
//
#import "VikingDataManager.h"
@implementation VikingDataManager

@synthesize someProperty;

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
        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(UIImage *)findMainActivityImage:(NSString *)imageName {
    //NSLog(@"just entered loadRemoteImage with imageName : %@",imageName);
    //return [UIImage imageNamed:imageName];
    NSString *imageRelativePath = [NSString stringWithFormat:@"http://robertscottpalmer.com/viking/Images.xcassets/%@.imageset/%@@3x.png", imageName,imageName];
    imageRelativePath = @"http://robertscottpalmer.com/viking/images/Water@2x.png";
    NSLog(@"Before call url for: %@",imageRelativePath);
    UIImage *intenetActivityImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageRelativePath]]];
    NSLog(@"after call url");
    return intenetActivityImage;
}

@end