//
//  ListCell.h
//  Viking
//
//  Created by macmini08 on 30/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RootCell_ID     @"RootCellID"
#define RootCell_XIB    @"ListCell"
#define RootCell_XIB_6P    @"ListCell_6P"
#define RootCell_XIB_6    @"ListCell_6"
#define RootCell_SIZE_FOR_5   CGSizeMake(78, 86)
#define RootCell_SIZE_FOR_6   CGSizeMake(88, 96)
#define RootCell_SIZE_FOR_6P   CGSizeMake(90, 99)

@interface ListCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *hexImege;

// Cell nib
+ (UINib *)cellNib;

// Configuration
- (void)configureWithInt:(NSInteger)anInteger;

@end
