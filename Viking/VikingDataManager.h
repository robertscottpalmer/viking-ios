//
//  VikingDataManager.h
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//

#import <Foundation/Foundation.h>
@interface VikingDataManager : NSObject {
    NSString *someProperty;
}

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;

@end
