//
//  CreateTripVC.h
//  Viking
//
//  Created by macmini08 on 27/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CreateTripVC : UIViewController
{
    NSString *activityTypeStr;
    NSString *durationTypeStr;
    NSString *tempTypeStr;
}

@property (nonatomic, weak) IBOutlet UIView *activityView;
@property (nonatomic, weak) IBOutlet UIView *durationView;
@property (nonatomic, weak) IBOutlet UIView *tempView;
@property (nonatomic, weak) IBOutlet UIView *nameView;

@property (nonatomic, weak) IBOutlet UIImageView *activityImgView;
@property (nonatomic, weak) IBOutlet UIImageView *durationImgView;
@property (nonatomic, weak) IBOutlet UIImageView *tempImgView;
@property (nonatomic, weak) IBOutlet UIImageView *headerBGView;
@property (nonatomic, weak) IBOutlet UIImageView *durationHeaderBGView;
@property (nonatomic, weak) IBOutlet UIImageView *tempHeaderBGView;
@property (nonatomic, weak) IBOutlet UIImageView *generateHeaderBGView;
@property (nonatomic, weak) IBOutlet UIImageView *headerBGIcon;

@property (nonatomic, weak) IBOutlet UITableView *activityTable;
@property (nonatomic, weak) IBOutlet UITableView *durationTable;
@property (nonatomic, weak) IBOutlet UITableView *tempTable;

@property (nonatomic, strong) IBOutlet UIView *selectionView;
@property (nonatomic, weak) IBOutlet UITextField *activityNameTxt;
@property (nonatomic, weak) IBOutlet UILabel *mainHeaderLbl;
@property (nonatomic, weak) IBOutlet UILabel *activityHeaderLbl;
@property (nonatomic, weak) IBOutlet UILabel *durationHeaderLbl;
@property (nonatomic, weak) IBOutlet UILabel *tempHeaderLbl;
@property (nonatomic, weak) IBOutlet UILabel *createHeaderLbl;

@property (nonatomic, strong) NSArray *subActivityArr;
@property (nonatomic) NSString *selectedActivityId;

@end
