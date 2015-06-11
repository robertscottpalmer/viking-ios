//
//  CCHexagonFlowLayout.h
//  Viking
//
//  Created by macmini08 on 30/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCHexagonDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@end

@interface CCHexagonFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat gap;

// Delegate
@property (nonatomic, assign) id<CCHexagonDelegateFlowLayout> delegate;

@end
