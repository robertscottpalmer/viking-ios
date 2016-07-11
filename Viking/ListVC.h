//
//  ListVC.h
//  Viking
//
//  Created by macmini08 on 30/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCHexagonFlowLayout.h"
#import "AppDelegate.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface ListVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CCHexagonDelegateFlowLayout>
{
    //NSString *tripId;
    //int totalCount;
    NSString *headerStr;
    //NSDictionary *activityDict;
    int currentIndex;
}

@property (nonatomic, strong) NSString *tripId; //this should be the only global property after some time.

@property (nonatomic, weak) IBOutlet UIView *actionView;
@property (nonatomic, weak) IBOutlet UILabel *headerLbl;
@property (nonatomic, weak) IBOutlet UILabel *activityNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *mainHeaderLbl;
@property (nonatomic, strong) NSString *headerStr;
@property (nonatomic, strong) NSDictionary *activityDict;

@property (nonatomic, strong) IBOutlet UIView *selectionView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *menuView;

@property (nonatomic, strong) IBOutlet UIView *view1;
@property (nonatomic, strong) IBOutlet UIView *view2;

@property (nonatomic, weak) IBOutlet UIView *collectionListsView;
@property (nonatomic, weak) IBOutlet UIView *collectionListsView1;

@property (nonatomic, weak) IBOutlet UIScrollView *scrlView;

@property (nonatomic, weak) IBOutlet UIButton *BtnAddItem;
@property (nonatomic, weak) IBOutlet UIButton *BtnRenameList;
@property (nonatomic, weak) IBOutlet UIButton *BtnResetList;
@property (nonatomic, weak) IBOutlet UIButton *BtnDeleteList;
@property (nonatomic, weak) IBOutlet UIButton *BtnRight;
@property (nonatomic, weak) IBOutlet UIButton *BtnLeft;

@property (nonatomic, weak) IBOutlet UIImageView *rightImgView;
@property (nonatomic, weak) IBOutlet UIImageView *leftImgView;
@property (nonatomic, weak) IBOutlet UIImageView *headerBGView;

@property (nonatomic) int currentIndex;
@property (nonatomic) NSInteger totalIndex;

@property (nonatomic, strong) UIView *actView;

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSArray *activityListArray;

@property (nonatomic) BOOL isFromCreateTrip;

@property (nonatomic, strong) NSManagedObject *myTripObj;

@end
