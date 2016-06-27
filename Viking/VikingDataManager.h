//
//  VikingDataManager.h
//  Viking
//
//  Created by Robert Palmer on 6/27/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef ImageManager_h
#define ImageManager_h

@interface VikingDataManager : NSObject {
}

@property (nonatomic, retain) NSString *apiServer;

-(UIImage *)findMainActivityImage:(NSString *)imageName;
+ (id)sharedManager;

@end

#endif /* ImageManager_h */
