//
//  MainVC.m
//  Viking
//
//  Created by macmini08 on 27/01/15.
//  Copyright (c) 2015 Space O Technology. All rights reserved.
//

#import "MainVC.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "AppConstant.h"
#import "Reachability.h"
#import "VikingDataManager.h"

@interface MainVC ()<MFMailComposeViewControllerDelegate>
{
    NSMutableData *_responseData;
    NSArray *postsArray;
    Reachability *internetReachability;
    UITapGestureRecognizer *tapGR;
    
    VikingDataManager *vikingDataManager;
}
@end


@implementation MainVC

@synthesize viewControllers;

#define X_OFFSET 35
#define Y_OFFSET 10


- (void)viewDidLoad {
    [super viewDidLoad];
    vikingDataManager = [VikingDataManager sharedManager];
    
    self.bottomLbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:15.0];
    self.betaLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0];
    
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.scrollView addGestureRecognizer: tapGR];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"codebeautify" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
  NSError* error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    
    NSArray *equip = result[@"GearList"][@"MainActivity"][@"SubActivity"][@"equipment_list"];
    
//    NSLog(@"list - %@", equip);
   
    self.fbIndication.hidden = YES;
    
    self.facebookPostView.hidden = YES;
    internetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No internet available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert show];
            break;
        }
        case ReachableViaWiFi:
        {
            [self facebookPostCall];
            break;
        }
        case ReachableViaWWAN:
        {
            [self facebookPostCall];
            break;
        }
    }
    
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.layer.cornerRadius = 65.0f;
//    visualEffectView.layer.masksToBounds = YES;
//    
//    visualEffectView.frame = self.tripNewImage.frame;
//    [self.view addSubview:visualEffectView];
//    
//    [self.view bringSubviewToFront:self.tripNewImage];
}

-(void)facebookPostCall
{
    
    self.facebookPostView.hidden = NO;
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token?client_id=%@&client_secret=%@&grant_type=client_credentials",FB_APP_ID, FB_SECRET_KEY]]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Do any additional setup after loading the view.

}

-(IBAction)featuredListClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This feature not available yet. Check back soon." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSString *responseStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"resposne - %@", responseStr);
    
    NSString *access_token;
    NSRange access_token_range = [responseStr rangeOfString:@"access_token="];
    if (access_token_range.length > 0) {
        int from_index = access_token_range.location + access_token_range.length;
        access_token = [responseStr substringFromIndex:from_index];
        
        //NSLog(@"access_token:  %@", access_token);
    }
    
    [self getFacebookPosts:access_token];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendEmailClicked:(id)sender {
    // Email Subject
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail])
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
        
        
        NSString *emailTitle = @"Feedback on Home";
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

-(void)getFacebookPosts:(NSString *)accessToken
{
    self.fbIndication.hidden = NO;
    [self.fbIndication startAnimating];
    
    postsArray  = [vikingDataManager getMainViewMessages];
    
    [self setUpScrollView];
    [self.fbIndication stopAnimating];
     self.fbIndication.hidden = YES;
}

-(void)setUpScrollView
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [postsArray count]; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [postsArray count], self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = [postsArray count];
    self.pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= [postsArray count]) return;
    
    // replace the placeholder if necessary
    UILabel *postLabel = [viewControllers objectAtIndex:page];
    if((NSNull *)postLabel == [NSNull null])
    {
       // NSLog(@"page - %d", page);
        
        postLabel = [[UILabel alloc] init];
        postLabel.numberOfLines = 0.0;
        postLabel.tag = page;
        postLabel.textColor = [UIColor whiteColor];
        postLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:15.0];
        postLabel.text = [NSString stringWithFormat:@"@TheVikingApp \n %@", postsArray[page][@"message"]];
        postLabel.backgroundColor = [UIColor clearColor];
//        [postLabel addGestureRecognizer:tapGR];
       
        [viewControllers replaceObjectAtIndex:page withObject:postLabel];
    }
    
    
    // add the controller's view to the scroll view
    if (nil == postLabel.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page + X_OFFSET;
        frame.origin.y = 10;
        frame.size.width = self.scrollView.frame.size.width - 2*X_OFFSET;
        frame.size.height = self.scrollView.frame.size.height - 2*Y_OFFSET;
        postLabel.frame = frame;
//         postLabel.frame = CGRectMake(self.scrollView.frame.origin.x + X_OFFSET, self.scrollView.frame.origin.x + Y_OFFSET, self.scrollView.frame.size.width - 2*X_OFFSET, self.scrollView.frame.size.height - 2*Y_OFFSET);
        [self.scrollView addSubview:postLabel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (self.pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = self.pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
}


-(void) labelTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    //BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    NSString *idStr = postsArray[self.pageControl.currentPage][@"id"];
    NSArray *arr = [idStr componentsSeparatedByString:@"_"];
    NSString * firstString;
    NSString * secondString;
    if (arr)
    {
        firstString = [arr objectAtIndex:0];
        secondString = [arr objectAtIndex:1];
        //NSLog(@"First String %@",firstString);
        //NSLog(@"Second String %@",secondString);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We should follow a link here???" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Here is where we should kick off a background load.");
}

@end
