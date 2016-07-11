//
//  MyTripVC.m
//  Viking
//
//  Created by macmini08 on 31/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import "MyTripVC.h"
#import <MessageUI/MessageUI.h>
#import "NewTripVC.h"
#import "MyActivityListCell.h"
#import "ListVC.h"
#import "VikingDataManager.h"

@interface MyTripVC () <MFMailComposeViewControllerDelegate>
{
    NSArray *activityListArray;
    VikingDataManager *vikingDataManager;
}

@end

@implementation MyTripVC

- (void)viewDidLoad {
    [super viewDidLoad];
    vikingDataManager = [VikingDataManager sharedManager];
    self.mainHeaderLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
    self.headerLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:15.0];
    // Do any additional setup after loading the view.
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add the effect view to the image view
    [self.addNewTripBg addSubview:effectView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchMyActivityList];
    [self.mytripTable reloadData];
}

#pragma mark - Core Data
-(void)fetchMyActivityList
{
    activityListArray = [vikingDataManager getMyTrips];
    activityListArray = [[activityListArray reverseObjectEnumerator] allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([activityListArray count]==0)
        return 1;
    else
        return [activityListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([activityListArray count]==0)
        return 44.0;
    else
        return 122;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([activityListArray count]==0)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }

        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"No trips found.";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        MyActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyActivityListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.subActivityLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:18.0];
        cell.activityNameLbl.font = [UIFont fontWithName:@"ProximaNova-Black" size:18.0];

        NSManagedObject *obj = activityListArray[indexPath.row];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        cell.activityNameLbl.text = @"I should call out to get name";
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey now." message:@"You should call out to the newly built api functions to get the needed values about to be displayed below" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alert show];
        
        NSString *tripName = [[obj valueForKey:@"name"] capitalizedString];
        NSString *activityId = [obj valueForKey:@"activityId"];
        NSDictionary *activity = [vikingDataManager getActivity:activityId];
        NSDictionary *activityType = [vikingDataManager getActivityType:activity[@"type"]];
        cell.subActivityLbl.text = activity[@"name"];
        // [NSString stringWithFormat:@"%@", [obj valueForKey:@"sub_activity"]];
        cell.activityNameLbl.text = tripName;//[activityType[@"name"] capitalizedString];
        //[[obj valueForKey:@"activityList_Name"] capitalizedString];
        [vikingDataManager loadSubActivityHorizontalBackground:cell.bgImage: activityId];
        //cell.bgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", [obj valueForKey:@"main_Activity"],[obj valueForKey:@"sub_activity"]]];
        //NSLog(@"image name - %@", [NSString stringWithFormat:@"%@_%@", [obj valueForKey:@"main_Activity"],[obj valueForKey:@"sub_activity"]]);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([activityListArray count]>0)
    {
        NSManagedObject *obj = activityListArray[indexPath.row];
        NSLog(@"row - %ld", (long)indexPath.row);
        ListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListView"];
        vc.headerStr = [NSString stringWithFormat:@"%@ %@", [obj valueForKey:@"sub_activity"],[obj valueForKey:@"main_Activity"]];
        vc.activityDict = nil;
        vc.isFromCreateTrip = NO;
        vc.myTripObj = obj;
        vc.activityListArray = activityListArray;
        vc.currentIndex = (int)indexPath.row;
        //    vc.listArray = equipmentListArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)backClick:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)sendEmailClicked:(id)sender {
    // Email Subject
    
     MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail])
    {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSLog(@"image - %@", snapShotImage);
        
        NSData *jpegData = UIImageJPEGRepresentation(snapShotImage, 1);
        NSString *fileName = @"Scrren_Shot";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [mc addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];

        
        NSString *emailTitle = @"Feedback on My Trips";
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


-(IBAction)newTripClicked:(id)sender
{
    NewTripVC *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NewTripView"];
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
