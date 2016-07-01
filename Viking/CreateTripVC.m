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
    NSManagedObjectContext *context;
    VikingDataManager *vikingDataManager;
}

@property (nonatomic, strong) NSMutableDictionary *activityDict;
@property (nonatomic, strong) NSMutableDictionary *durationDict;
@property (nonatomic, strong) NSMutableDictionary *tempDict;

@end

@implementation CreateTripVC

@synthesize subActivityArr, selectedActivityTypeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    vikingDataManager = [VikingDataManager sharedManager];
    
    [AppDelegate hideGlobalHUD];
    
    self.mainHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
    self.activityHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15.0];
    self.durationHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15.0];
    self.tempHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15.0];
    self.createHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15.0];

    self.headerBGIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", selectedActivityTypeId]];
    
    context = [self managedObjectContext];
    
    self.activityNameTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Name your trip"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor colorWithRed:123.0/255.0 green:137.0/255.0 blue:148.0/255.0 alpha:1.0],
                                                 NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Bold" size:18.0]
                                                 }
     ];
    
    // Do any additional setup after loading the view.
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.activityDict = [[NSMutableDictionary alloc] init];
    self.durationDict = [[NSMutableDictionary alloc] init];
    self.tempDict = [[NSMutableDictionary alloc] init];
    
    self.activityView.hidden = NO;
    self.durationView.hidden = YES;
    self.tempView.hidden = YES;
    self.nameView.hidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    NSLog(@"Make sure we get to here!!!!");
    durationArr = [vikingDataManager getDurationArr];
    temperatureArr = [vikingDataManager getTemperatureArr];
    
    [self setHeaderBackground];
    
    [AppDelegate hideGlobalHUD];
}

-(void)setHeaderBackground
{
    self.headerBGView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG-%@",selectedActivityTypeId]];
    self.durationHeaderBGView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG-%@",selectedActivityTypeId]];
    self.tempHeaderBGView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG-%@",selectedActivityTypeId]];
    self.generateHeaderBGView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG-%@",selectedActivityTypeId]];
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

-(void)createSelectionView:(UIImage *)activityImage durationImg:(UIImage *)durationImage tempImg:(UIImage *)tempImage activityName:(NSDictionary *)activityStr durationName:(NSString *)durationStr tempName:(NSString *)tempStr inView:(UIView *)view
{
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
    
    activityImg.image = activityImage;
    activityImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:activityImg];
    
    if(IS_IPHONE_5)
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(36, 9, 71, 21)];
        activityLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    else if(IS_IPHONE_6P)
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 90, 40)];
        activityLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0];
        activityLbl.backgroundColor = [UIColor clearColor];
        
    }else if (IS_IPHONE_4_OR_LESS){  //Vikita
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, 71, 21)];
        activityLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
       
    }
    else
    {
        activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(42, 9, 71, 21)];
        activityLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    NSLog(@"the current value of activityStr is %@",activityStr);
    activityLbl.text = [activityStr[@"name"] uppercaseString];
    activityLbl.numberOfLines = 0;
    activityLbl.textColor = [UIColor whiteColor];
    activityLbl.textAlignment = NSTextAlignmentCenter;
    [self.selectionView addSubview:activityLbl];
    NSLog(@"made it FURTHER!!!");
    
    if(IS_IPHONE_5)
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 20, 17)];
    else if(IS_IPHONE_6P)
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(144, 20, 26, 21)];
    else if (IS_IPHONE_4_OR_LESS) //Vikita
          durImg = [[UIImageView alloc] initWithFrame:CGRectMake(114,12,15,15)];
    else
        durImg = [[UIImageView alloc] initWithFrame:CGRectMake(136, 10, 20, 17)];
    durImg.image = durationImage;
    durImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:durImg];
    
    
    if(IS_IPHONE_5)
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(149, 9, 73, 21)];
        durationLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    else if(IS_IPHONE_6P)
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(175, 12, 90, 40)];
        durationLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0];
        durationLbl.backgroundColor = [UIColor clearColor];
    }else if (IS_IPHONE_4_OR_LESS){ //Vikita
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(136, 9, 71, 21)];
        durationLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    else
    {
        durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(165, 9, 73, 21)];
        durationLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    durationLbl.text = [durationStr uppercaseString];
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
    tempImg.image = tempImage;
    tempImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectionView addSubview:tempImg];
    
    
    if(IS_IPHONE_5)
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(271, 9, 41, 21)];
        tempLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    else if(IS_IPHONE_6P)
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(315, 12, 90, 40)];
        tempLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0];
        tempLbl.backgroundColor = [UIColor redColor];
    }else if (IS_IPHONE_4_OR_LESS){//Vikita
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(242, 9, 71, 21)];
        tempLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];}
    else
    {
        tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(308, 9, 41, 21)];
        tempLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
    }
    tempLbl.backgroundColor = [UIColor clearColor];
    tempLbl.text = [tempStr uppercaseString];
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
        cell.activityLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        cell.activityLbl.text = [NSString stringWithFormat:@"%@", subActivityArr[indexPath.row][@"name"]];
        cell.activityImg.image = [UIImage imageNamed:@"ImageUnavailable"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            // Perform async operation
            // Call your method/function here
            UIImage *intenetActivityImage = [vikingDataManager findMainActivityImage:@"1"]; //TODO: don't hardcode!!!
            dispatch_sync(dispatch_get_main_queue(), ^{
                // Update UI
                cell.activityImg.image = intenetActivityImage;
            });
        });
        
        //[UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-%@", subActDict[@"name"], subActivityArr[indexPath.row]]];
        
        return cell;
    }
    else if(tableView == self.durationTable)
    {
        DurationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DurationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.durationLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        if(indexPath.row == 0)
            cell.durationLbl.text = [NSString stringWithFormat:@"Raid - %@",durationArr[indexPath.row]];
        else if (indexPath.row == 1)
            cell.durationLbl.text = [NSString stringWithFormat:@"Journey - %@",durationArr[indexPath.row]];
        else if (indexPath.row == 2)
            cell.durationLbl.text = [NSString stringWithFormat:@"Expedition - %@",durationArr[indexPath.row]];
        
        cell.durationImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", durationArr[indexPath.row]]];
        
        return cell;
    }
    else
    {
        TempTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TempCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tempLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        cell.tempLbl.text = temperatureArr[indexPath.row];
        cell.tempImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", temperatureArr[indexPath.row]]];
        
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
    if(tableView == self.activityTable)
    {
        ActivityTableCell* cell = (ActivityTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        
        self.activityView.hidden = YES;
        self.durationView.hidden = NO;
        self.tempView.hidden = YES;
        self.nameView.hidden = YES;
        
        [self.activityDict setObject:cell.activityImg.image forKey:@"image"];
        [self.activityDict setObject:subActivityArr[indexPath.row] forKey:@"title"];
        
        [self.durationTable reloadData];
        
        [self SwipeRight:self.durationView];
        [self setHeaderBackground];
    }
    else if(tableView == self.durationTable)
    {
        DurationTableCell* cell = (DurationTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        self.activityView.hidden = YES;
        self.durationView.hidden = YES;
        self.tempView.hidden = NO;
        self.nameView.hidden = YES;
        
        [self.durationDict setObject:cell.durationImg.image forKey:@"image"];
        [self.durationDict setObject:durationArr[indexPath.row] forKey:@"title"];
        [self.tempTable reloadData];
        
        [self SwipeRight:self.tempView];
    }
    else
    {
        TempTableCell* cell = (TempTableCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        self.activityView.hidden = YES;
        self.durationView.hidden = YES;
        self.tempView.hidden = YES;
        self.nameView.hidden = NO;
        
        [self.tempDict setObject:cell.tempImg.image forKey:@"image"];
        [self.tempDict setObject:cell.tempLbl.text forKey:@"title"];
        
        NSString *durationStr;
        if([self.durationDict[@"title"] isEqualToString:@"1 Day"]){
            durationStr = @"Raid";
        }
        else if ([self.durationDict[@"title"] isEqualToString:@"2 Days"]){
            durationStr = @"Journey";
        }
        else if ([self.durationDict[@"title"] isEqualToString:@"3+ Days"]){
            durationStr = @"Expedition";
        }
        
        UIImage *dbugActivityImage = self.activityDict[@"image"];
        UIImage *dbugDurationImage = self.durationDict[@"image"];
        UIImage *dbugTemperatureImage = cell.tempImg.image;
        NSString *dbugActivityName = self.activityDict[@"title"];
        
        [self createSelectionView:self.activityDict[@"image"] durationImg:self.durationDict[@"image"] tempImg:cell.tempImg.image activityName:self.activityDict[@"title"] durationName:durationStr tempName:cell.tempLbl.text inView:self.nameView];
        NSLog(@"About to crash while swiping to nameView %@",self.nameView);
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
    [self.activityNameTxt resignFirstResponder];
    if(![self.activityNameTxt.text length]>0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey now." message:@"Trip name can not be blank." delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        [dict setValue:self.activityDict[@"image"] forKey:@"ActivityImage"];
        [dict setValue:self.activityDict[@"title"] forKey:@"ActivityTitle"];
        [dict setValue:self.durationDict[@"image"] forKey:@"DurationImage"];
        [dict setValue:self.durationDict[@"title"] forKey:@"DurationTitle"];
        [dict setValue:self.tempDict[@"image"] forKey:@"TempImage"];
        [dict setValue:self.tempDict[@"title"] forKey:@"TempTitle"];
        
        appDel.activityDict = dict;
        
        NSArray *subActEquipmentArr;
        
        NSArray *subActArray = subActDict[@"Equipment_List"][@"Sub_Activity"];
        for(NSDictionary *subDict in subActArray)
        {
//            NSLog(@"name - %@", subDict[@"name"]);
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
        
        NSArray *equipmentListArr;
        for(NSDictionary *tempDict in durArr)
        {
            if([tempDict[@"name"] isEqualToString:dict[@"TempTitle"]])
            {
                equipmentListArr = tempDict[@"list"][@"equipment"];
            }
            
        }
        
        [self saveMyActivity:self.activityNameTxt.text equipmentList:equipmentListArr];
    }
    
}

-(void)saveMyActivity:(NSString *)activityName equipmentList:(NSArray *)list
{
    NSLog(@"????Is this where we're failing???? listPassed=%@",list);
    NSManagedObject *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"MyActivityList" inManagedObjectContext:context];
    [newActivity setValue:activityName forKey:@"activityList_Name"];
    [newActivity setValue:self.durationDict[@"title"] forKey:@"duration"];
    [newActivity setValue:selectedActivityTypeId forKey:@"main_Activity"];
    //NOTE: this should not be hard-coded
    [newActivity setValue:self.activityDict[@"title"][@"1"] forKey:@"sub_activity"];
    [newActivity setValue:self.tempDict[@"title"] forKey:@"temperature"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    

    for(NSDictionary *equipmentDict in list)
    {
         NSManagedObject *newActivityList = [NSEntityDescription insertNewObjectForEntityForName:@"MyActivityEquipmentList" inManagedObjectContext:context];
        [newActivityList setValue:activityName forKey:@"activityList_Name"];
        [newActivityList setValue:self.durationDict[@"title"] forKey:@"duration"];
//        [newActivityList setValue:selectedActivity forKey:@"main_Activity"];
        [newActivityList setValue:self.activityDict[@"title"] forKey:@"sub_activity"];
        [newActivityList setValue:self.tempDict[@"title"] forKey:@"temperature"];
        [newActivityList setValue:equipmentDict[@"name"] forKey:@"equipment"];
        [newActivityList setValue:@"hexa_orange" forKey:@"image"];
        
        NSError *error1 = nil;
        // Save the object to persistent store
        if (![context save:&error1]) {
            NSLog(@"Can't Save! %@ %@", error1, [error1 localizedDescription]);
        }
    }
    
//    [self fetchdata];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:self.activityDict[@"image"] forKey:@"ActivityImage"];
    [dict setValue:self.activityDict[@"title"] forKey:@"ActivityTitle"];
    [dict setValue:self.durationDict[@"image"] forKey:@"DurationImage"];
    [dict setValue:self.durationDict[@"title"] forKey:@"DurationTitle"];
    [dict setValue:self.tempDict[@"image"] forKey:@"TempImage"];
    [dict setValue:self.tempDict[@"title"] forKey:@"TempTitle"];
    [dict setValue:self.activityNameTxt.text forKey:@"activityListname"];
//    [dict setValue:selectedActivity forKey:@"main_Activity"];
    
    ListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListView"];
    vc.headerStr = self.activityNameTxt.text;
    vc.activityDict = dict;
    vc.isFromCreateTrip = YES;
    vc.myTripObj = nil;
//    vc.listArray = equipmentListArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)fetchdata
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SubActivities"];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSArray *subAct = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"data - %@", subAct);
    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequestList = [[NSFetchRequest alloc] initWithEntityName:@"MyActivityEquipmentList"];
    fetchRequestList.returnsObjectsAsFaults = NO;
    NSArray *sublist = [[managedObjectContext executeFetchRequest:fetchRequestList error:nil] mutableCopy];
//    NSLog(@"data - %@", sublist);

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:self.activityDict[@"image"] forKey:@"ActivityImage"];
    [dict setValue:self.activityDict[@"title"] forKey:@"ActivityTitle"];
    [dict setValue:self.durationDict[@"image"] forKey:@"DurationImage"];
    [dict setValue:self.durationDict[@"title"] forKey:@"DurationTitle"];
    [dict setValue:self.tempDict[@"image"] forKey:@"TempImage"];
    [dict setValue:self.tempDict[@"title"] forKey:@"TempTitle"];
    
    appDel.activityDict = dict;
    
    ListVC *vc = [segue destinationViewController];
    vc.headerStr = self.activityNameTxt.text;
    vc.activityDict = dict;
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
