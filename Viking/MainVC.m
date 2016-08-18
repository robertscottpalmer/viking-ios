//
//  MainVC.m
//  Viking

#import "MainVC.h"
#import <MessageUI/MessageUI.h>
#import "AppConstant.h"
#import "Reachability.h"
#import "VikingDataManager.h"

@interface MainVC ()<MFMailComposeViewControllerDelegate>
{
    
    NSMutableArray *postsArray;
    UITapGestureRecognizer *tapGR;
    VikingDataManager *vikingDataManager;
    UIFont *proximaLight15;
}
@end


@implementation MainVC

@synthesize viewControllers;

#define X_OFFSET 35
#define Y_OFFSET 10


- (void)viewDidLoad {
    [super viewDidLoad];
    proximaLight15 = [UIFont fontWithName:@"ProximaNova-Light" size:15.0];
    vikingDataManager = [VikingDataManager sharedManager];
    
    self.bottomLbl.font = proximaLight15;//[UIFont fontWithName:@"ProximaNova-Light" size:15.0];
    self.betaLbl.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0];
    
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.scrollView addGestureRecognizer: tapGR];
    [self facebookPostCall];
}

-(void)facebookPostCall
{
    self.fbIndication.hidden = YES;
    self.facebookPostView.hidden = YES;
    self.facebookPostView.hidden = NO;
    [self getFacebookPosts];
    // Do any additional setup after loading the view.
}

-(IBAction)featuredListClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This feature not available yet. Check back soon." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

-(void)getFacebookPosts
{
    self.fbIndication.hidden = NO;
    [self.fbIndication startAnimating];
    NSArray *somePosts = [vikingDataManager getMainViewMessages];
    postsArray = [[NSMutableArray alloc] init];
    [postsArray addObjectsFromArray:somePosts];
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
        NSLog(@"page - %d", page);
        
        postLabel = [[UILabel alloc] init];
        postLabel.numberOfLines = 0.0;
        postLabel.tag = page;
        postLabel.textColor = [UIColor whiteColor];
        postLabel.font = proximaLight15;//[UIFont fontWithName:@"ProximaNova-Light" size:15.0];
        postLabel.text = [NSString stringWithFormat:@"@TheVikingApp \n %@", postsArray[page][@"announcement_txt"]];
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
    int page = (int)self.pageControl.currentPage;
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
    NSURL *neededURL = [NSURL URLWithString:[vikingDataManager getUrlToOpen:postsArray[self.pageControl.currentPage]]];
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:neededURL];
    if (installed){
        [[UIApplication sharedApplication] openURL:neededURL];
    }else{
        [vikingDataManager showAlert:@"There is not an application on your phone that we can use to display this content"];
    }
}


@end
