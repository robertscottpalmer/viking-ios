//
//  ListCell.m
//  Viking
//
//  Created by macmini08 on 30/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import "ListCell.h"
#import "AppConstant.h"

@interface ListCell ()

// Outlets


@end


@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - Utils
static UINib *cellNib;
+ (UINib*)cellNib
{
    if (cellNib)
        return cellNib;
    
    // Build cell nib
    if(IS_IPHONE_5)
        cellNib = [UINib nibWithNibName:RootCell_XIB bundle:nil];
    else if (IS_IPHONE_6P )
        cellNib = [UINib nibWithNibName:RootCell_XIB_6P bundle:nil];
    else
        cellNib = [UINib nibWithNibName:RootCell_XIB_6 bundle:nil];
    
    return cellNib;
}

#pragma mark - Configuration
- (void)configureWithInt:(NSInteger)anInteger
{
//    _titleLabel.text = [NSString stringWithFormat:@"%d", anInteger];
}


@end
