//
//  CreateTripVC.m
//  Viking
//
//  Created by macmini08 on 27/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import "CreateTripVC.h"
#import "ActivityTableCell.h"
#import "DurationTableCell.h"
#import "TempTableCell.h"
#import "ListVC.h"
#import "MainVC.h"
#import <MessageUI/MessageUI.h>
#import "AppConstant.h"
#import "MyTripVC.h"
#import "VikingDataManager.h"

@interface CreateTripVC () <MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDel;
    NSDictionary *subActDict;
    NSArray *durationArr;
    NSArray *temperatureArr;
    VikingDataManager *vikingDataManager;
    UIFont *bold15,*light18,*regular12,*regular15;
}

@property (nonatomic, strong) NSMutableDictionary *userSelectionDict;

@end

@implementation CreateTripVC

@synthesize subActivityArr, selectedActivityTypeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bold15 = [UIFont fontWithName:@"ProximaNova-Bold" size:15.0];
    light18 = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
    regular12 = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    regular15 = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0];
    
    vikingDataManager = [VikingDataManager sharedManager];
    
    [AppDelegate hideGlobalHUD];
    
    self.mainHeaderLbl.font = light18;
    self.activityHeaderLbl.font = bold15;
    self.durationHeaderLbl.font = bold15;
    self.tempHeaderLbl.font = bold15;
    self.createHeaderLbl.font = bold15;
    
    [vikingDataManager loadMainActivityIcon:self.headerBGIcon :selectedActivityTypeId];
    
    self.tripNameTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Name your trip"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor colorWithRed:123.0/255.0 green:137.0/255.0 blue:148.0/255.0 alpha:1.0],
                                                 NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Bold" size:18.0]
                                                 }
     ];
    
    // Do any additional setup after loading the view.
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.userSelectionDict = [[NSMutableDictionary alloc] init];
    
    self.activityView.hidden = NO;
    self.durationView.hidden = YES;
    self.tempView.hidden = YES;
    self.nameView.hidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    durationArr = [vikingDataManager getDurationArr];
    temperatureArr = [vikingDataManager getTemperatureArr];
    
    [self setHeaderBackground];
    
    [AppDelegate hideGlobalHUD];
}

-(void)setHeaderBackground
{
    [vikingDataManager loadMainActivityBanner:self.headerBGView :selectedActivityTypeId];
    [vikingDataManager loadMainActivityBanner:self.durationHeaderBGView :selectedActivityTypeId];
    [vikingDataManager loadMainActivityBanner:self.tempHeaderBGView :selectedActivityTypeId];
    [vikingDataManager loadMainActivityBanner:self.generateHeaderBGView :selectedActivityTypeId];
}

- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSelectionView:(NSDictionary *)userSelections inView:(UIView *)view
{
    /**
     original argument view
     (UIImage *)activityImage durationImg:(UIImage *)durationImage tempImg:(UIImage *)tempImage activityName:(NSDictionary *)activityStr durationName:(NSString *)durationStr tempName:(NSString *)tempStr inView:(UIView *)view
     */
    
    if(self.selectionView)
    {
        [self.selectionView removeFromSuperview];
    }
    
    self.selectionView = [[UIView alloc] init];
   
    
    float barHeight;
    if(IS_IPHONE_6P)
        barHeight = 59.0;
    else if (IS_IPHONE_5)
        barHeight = 39.0;
    else
        barHeight = 39.0;
    
    self.selectionView.frame = CGRectMake(self.view.bounds.origin.x, self.generateHeaderBGView.frame.size.height - barHeight, self.view.bounds.size.width, barHeight);
    
    
    self.selectionView.backgroundColor = [UIColor clearColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.selectionView.frame.size.width, self.selectionView.frame.size.height)];
    [img setImage:[UIImage imageNamed:@"blur_strip"]];
    [self.selectionView addSubview:img];
    
    UIImageView *activityImg;
    UIImageView *durImg;
    UIImageView *tempImg;
    UILabel *activityLbl;
    UILabel *durationLbl;
    UILabel *tempLbl;
    UILabel *deviderLbl;
    UILabel *deviderLbl2;
    
    
    if(IS_IPHONE_5)
        activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 20, 20)];
    else if(IS_IPHONE_6P)
        activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 30, 30)];
    else if (IS_IPHONE_4_OR_LESS)
        activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 20, 20)]; //Vikita
    else
        activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 20, 20)];
    
    //activityImg.image = userSelections[@"activity_image"];
    [vikingDataManager loadSubActivityIcon:activityImg :userSelections[USER_SELECTED_ACTIVITY][@"id"]];
    activityImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:activityImg];
    
    if(IS_IPHONE_5)
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(36, 9, 71, 21)];
        activityLbl.font = regular12;
    }
    else if(IS_IPHONE_6P)
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 90, 40)];
        activityLbl.font = regular15;
        activityLbl.backgroundColor = [UIColor clearColor];
        
    }else if (IS_IPHONE_4_OR_LESS){  //Vikita
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, 71, 21)];
        activityLbl.font = regular12;
       
    }
    else
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(42, 9, 71, 21)];
        activityLbl.font = regular12;
    }
    activityLbl.text = [userSelections[USER_SELECTED_ACTIVITY][@"name"] uppercaseString];
    activityLbl.numberOfLines = 0;
    activityLbl.textColor = [UIColor whiteColor];
    activityLbl.textAlignment = NSTextAlignmentCenter;
    [self.selectionView addSubview:activityLbl];
    
    if(IS_IPHONE_5)
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 20, 17)];
    else if(IS_IPHONE_6P)
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(144, 20, 26, 21)];
    else if (IS_IPHONE_4_OR_LESS) //Vikita
          durImg = [[UIImageView alloc] initWithFrame:CGRectMake(114,12,15,15)];
    else
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(136, 10, 20, 17)];
    //durImg.image = userSelections[@"duration_image"];
    [vikingDataManager loadDurationIcon:durImg :userSelections[USER_SELECTED_DURATION][@"id"]];
    durImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:durImg];
    
    
    if(IS_IPHONE_5)
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(149, 9, 73, 21)];
        durationLbl.font = regular12;
    }
    else if(IS_IPHONE_6P)
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(175, 12, 90, 40)];
        durationLbl.font = regular15;
        durationLbl.backgroundColor = [UIColor clearColor];
    }else if (IS_IPHONE_4_OR_LESS){ //Vikita
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(136, 9, 71, 21)];
        durationLbl.font = regular12;
    }
    else
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(165, 9, 73, 21)];
        durationLbl.font = regular12;
    }
    durationLbl.text = [userSelections[USER_SELECTED_DURATION][@"name"] uppercaseString];
    durationLbl.textAlignment = NSTextAlignmentCenter;
    durationLbl.textColor = [UIColor whiteColor];
    [self.selectionView addSubview:durationLbl];

    
    if(IS_IPHONE_5)
        tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(250, 10, 8, 20)];
    else if(IS_IPHONE_6P)
        tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(284, 15, 26, 26)];
    else if (IS_IPHONE_4_OR_LESS)//Vikita
       
        tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(224, 10, 10, 15)];
    else
        tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(277, 10, 8, 20)];
    //tempImg.image = userSelections[@"temperature_image"];
    [vikingDataManager loadTemperatureIcon:tempImg :userSelections[USER_SELECTED_TEMPERATURE][@"id"]];
    tempImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:tempImg];
    
    
    if(IS_IPHONE_5)
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(271, 9, 41, 21)];
        tempLbl.font = regular12;
    }
    else if(IS_IPHONE_6P)
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(315, 12, 90, 40)];
        tempLbl.font = regular15;
        tempLbl.backgroundColor = [UIColor redColor];
    }else if (IS_IPHONE_4_OR_LESS){//Vikita
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(242, 9, 71, 21)];
        tempLbl.font = regular12;
    }
    else
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(308, 9, 41, 21)];
        tempLbl.font = regular12;
    }
    tempLbl.backgroundColor = [UIColor clearColor];
    tempLbl.text = [userSelections[USER_SELECTED_TEMPERATURE][@"name"] uppercaseString];
    tempLbl.textAlignment = NSTextAlignmentCenter;
    tempLbl.textColor = [UIColor whiteColor];
    
    [self.selectionView addSubview:tempLbl];
    
    if(IS_IPHONE_5)
        deviderLbl = [[UILabel alloc] initWithFrame:CGRectMake(108, 4, 1, 32)];
    else if (IS_IPHONE_6P)
        deviderLbl = [[UILabel alloc] initWithFrame:CGRectMake(137, 4, 1, barHeight-8)];
    else if (IS_IPHONE_4_OR_LESS)//Vikita
        deviderLbl = [[UILabel alloc] initWithFrame:CGRectMake(106, 4, 1, 32)];
    else
        deviderLbl = [[UILabel alloc] initWithFrame:CGRectMake(124, 4, 1, 32)];
    
    deviderLbl.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:141.0/255.0 blue:145.0/255.0 alpha:1.0];
    [self.selectionView addSubview:deviderLbl];
    
    if(IS_IPHONE_5)
        deviderLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(233, 4, 1, 32)];
    else if (IS_IPHONE_6P)
        deviderLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(276, 4, 1, barHeight-8)];
    else  if (IS_IPHONE_4_OR_LESS)//Vikita
        deviderLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(212, 4, 1, 32)]; //Vikita
    else
        deviderLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(249, 4, 1, 32)];
    
    deviderLbl2.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:141.0/255.0 blue:145.0/255.0 alpha:1.0];
    [self.selectionView addSubview:deviderLbl2];
    
    [view addSubview:self.selectionView];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.activityTable)
        return [subActivityArr count];
    else if (tableView == self.durationTable)
        return [durationArr count];
    else
        return [temperatureArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.activityTable)
    {
        ActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activityLbl.font = light18;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        cell.activityLbl.text = [NSString stringWithFormat:@"%@", subActivityArr[indexPath.row][@"name"]];
        
        [vikingDataManager loadSubActivityIcon:cell.activityImg :subActivityArr[indexPath.row][@"id"]];
        
        return cell;
    }
    else if(tableView == self.durationTable)
    {
        DurationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DurationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.durationLbl.font = light18;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        NSDictionary *currDuration = durationArr[indexPath.row];
        cell.durationLbl.text = [NSString stringWithFormat:@"%@ - %@",currDuration[@"name"],currDuration[@"description"]];
        //cell.durationImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", currDuration[@"description"]]];
        [vikingDataManager loadDurationIcon:cell.durationImg :currDuration[@"id"]];
        return cell;
    }
    else
    {
        TempTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TempCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tempLbl.font = light18;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        NSDictionary *currTemp = temperatureArr[indexPath.row];
        cell.tempLbl.text = currTemp[@"name"];
        [vikingDataManager loadTemperatureIcon:cell.tempImg :currTemp[@"id"]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPHONE_6P)
    {
        if(tableView == self.activityTable)
            return 90;
        else if(tableView == self.durationTable)
            return 92;
        else
            return 90;

    }
    else if (IS_IPHONE_6)
    {
        if(tableView == self.activityTable)
            return 69;
        else if(tableView == self.durationTable)
            return 92;
        else
            return 69;

    }
    else if(IS_IPHONE_5)
    {
        if(tableView == self.activityTable)
            return 69;
        else if(tableView == self.durationTable)
            return 92;
        else
            return 69;
    }
    else if (IS_IPHONE_4_OR_LESS){
        if(tableView == self.activityTable)
            return 65;
        else if(tableView == self.durationTable)
            return 65;
        else
            return 65;
        
    }else
        return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The following row was selected : %ld",(long)indexPath.row);
    if(tableView == self.activityTable)
    {
        //ActivityTableCell* cell = (ActivityTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        self.activityView.hidden = YES;
        self.durationView.hidden = NO;
        self.tempView.hidden = YES;
        self.nameView.hidden = YES;
        
        //[self.userSelectionDict setObject:cell.activityImg.image forKey:USER_SELECTED_ACTIVITY_IMAGE];
        [self.userSelectionDict setObject:subActivityArr[indexPath.row] forKey:USER_SELECTED_ACTIVITY];
        
        [self.durationTable reloadData];
        
        [self SwipeRight:self.durationView];
        [self setHeaderBackground];
    }
    else if(tableView == self.durationTable)
    {
        //DurationTableCell* cell = (DurationTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        self.activityView.hidden = YES;
        self.durationView.hidden = YES;
        self.tempView.hidden = NO;
        self.nameView.hidden = YES;
        
        //[self.userSelectionDict setObject:cell.durationImg.image forKey:USER_SELECTED_DURATION_IMAGE];
        [self.userSelectionDict setObject:durationArr[indexPath.row] forKey:USER_SELECTED_DURATION];
        [self.tempTable reloadData];
        
        [self SwipeRight:self.tempView];
    }
    else
    {
        //TempTableCell* cell = (TempTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        self.activityView.hidden = YES;
        self.durationView.hidden = YES;
        self.tempView.hidden = YES;
        self.nameView.hidden = NO;
        //[self.userSelectionDict setObject:cell.tempImg.image forKey:USER_SELECTED_TEMPERATURE_IMAGE];
        [self.userSelectionDict setObject:temperatureArr[indexPath.row] forKey:USER_SELECTED_TEMPERATURE];
        [self createSelectionView:self.userSelectionDict inView:self.nameView];
        [self SwipeRight:self.nameView];
    }
}


-(IBAction)durationBackClicked:(id)sender
{
    self.activityView.hidden = NO;
    self.durationView.hidden = YES;
    self.tempView.hidden = YES;
    self.nameView.hidden = YES;
    [self.activityTable reloadData];
    [self SwipeLeft:self.activityView];
}


-(IBAction)tempBackClicked:(id)sender
{
    self.activityView.hidden = YES;
    self.durationView.hidden = NO;
    self.tempView.hidden = YES;
    self.nameView.hidden = YES;
    [self.durationTable reloadData];
    [self SwipeLeft:self.durationView];
}


-(IBAction)nameBackClicked:(id)sender
{
    self.activityView.hidden = YES;
    self.durationView.hidden = YES;
    self.tempView.hidden = NO;
    self.nameView.hidden = YES;
    [self.tempTable reloadData];
    [self SwipeLeft:self.tempView];
}

-(void)SwipeRight:(UIView *)view{
    
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:kCATransition];
}

-(void)SwipeLeft:(UIView *)view{
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:kCATransition];
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *managedcontext = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        managedcontext = [delegate managedObjectContext];
    }
    return managedcontext;
}


-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldShouldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)generateListClicked:(id)sender
{
    [self.tripNameTxt resignFirstResponder];
    if(! ([self.tripNameTxt.text length] > 0) )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey now." message:@"Trip name can not be blank." delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSArray *subActEquipmentArr;
        
        NSArray *subActArray = subActDict[@"Equipment_List"][@"Sub_Activity"];
        for(NSDictionary *subDict in subActArray)
        {
            if([subDict[@"name"] isEqualToString:dict[@"ActivityTitle"]])
            {
                subActEquipmentArr = subDict[@"Duration"];
            }
        }
        
        NSArray *durArr;
        for(NSDictionary *durationDict in subActEquipmentArr)
        {
            if([durationDict[@"day"] isEqualToString:dict[@"DurationTitle"]])
            {
                durArr = durationDict[@"temperature"];
            }
        }
        [self saveMyActivity:self.tripNameTxt.text];
    }
}

-(void)saveMyActivity:(NSString *)activityName
{
    NSString *tripId = [vikingDataManager createNewTrip:activityName : self.userSelectionDict];
    ListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListView"];
    vc.tripId = tripId;
    vc.headerStr = self.tripNameTxt.text;
    //vc.activityDict = dict;
    vc.isFromCreateTrip = YES;
    //vc.myTripObj = nil;
    //    vc.listArray = equipmentListArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)fetchdata
{
    //NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SubActivities"];
    fetchRequest.returnsObjectsAsFaults = NO;
//    NSArray *subAct = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"data - %@", subAct);
    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequestList = [[NSFetchRequest alloc] initWithEntityName:@"MyActivityEquipmentList"];
    fetchRequestList.returnsObjectsAsFaults = NO;
//    NSArray *sublist = [[managedObjectContext executeFetchRequest:fetchRequestList error:nil] mutableCopy];
//    NSLog(@"data - %@", sublist);

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSMutableDictionary *dict = [NSMutableDictionary new];
    
//    [dict setValue:self.activityDict[@"image"] forKey:@"ActivityImage"];
//    [dict setValue:self.activityDict[@"title"] forKey:@"ActivityTitle"];
//    [dict setValue:self.durationDict[@"image"] forKey:@"DurationImage"];
//    [dict setValue:self.durationDict[@"title"] forKey:@"DurationTitle"];
//    [dict setValue:self.tempDict[@"image"] forKey:@"TempImage"];
//    [dict setValue:self.tempDict[@"title"] forKey:@"TempTitle"];
//    
    //appDel.activityDict = dict;
    
    ListVC *vc = [segue destinationViewController];
    vc.headerStr = self.tripNameTxt.text;
    //vc.activityDict = dict;
}

-(IBAction)sendEmailClicked:(id)sender {
    // Email Subject]
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail])
    {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
//        NSLog(@"image - %@", snapShotImage);
        
        NSData *jpegData = UIImageJPEGRepresentation(snapShotImage, 1);
        NSString *fileName = @"Scrren_Shot";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [mc addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];

        
        NSString *emailTitle = @"Feedback on New Trip";
        // Email Content
        NSString *messageBody = @"";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"info@thevikingapp.com"];
        
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
