//
//  MyTripVC.h
//  Viking
//
//  Created by macmini08 on 31/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyTripVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *mytripTable;
@property (nonatomic, weak) IBOutlet UILabel *mainHeaderLbl;
@property (nonatomic, weak) IBOutlet UILabel *headerLbl;
@property (nonatomic, weak) IBOutlet UIImageView *addNewTripBg;

@end
