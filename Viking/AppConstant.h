
#import "AppDelegate.h"


#define APP_NAME @"Viking"

#define LocalURL       @"http://main.spaceotechnologies.com/point_mom/api/"

/*****
 * start user selection keys
 *****/
#define USER_SELECTED_ACTIVITY_ID =       @"USER_SELECTED_ACTIVITY_ID"
#define USER_SELECTED_DURATION_ID =       @"USER_SELECTED_DURATION_ID"
#define USER_SELECTED_TEMPERATURE_ID =    @"USER_SELECTED_TEMPERATURE_ID"
#define USER_SELECTED_ACTIVITY_IMAGE =    @"USER_SELECTED_ACTIVITY_IMAGE"
#define USER_SELECTED_DURATION_IMAGE =    @"USER_SELECTED_DURATION_IMAGE"
#define USER_SELECTED_TEMPERATURE_IMAGE = @"USER_SELECTED_TEMPERATURE_IMAGE"

/*****
 * end user selection keys
 *****/

#define AppDel ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define FB_APP_ID @"1589311797992966"
#define FB_SECRET_KEY @"b6c75444f589c99b8a54f1fa21555112"

//#define objShare [SharedClass objSharedClass]

//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568.0 ) < DBL_EPSILON )


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define CURRENTMODEL [[UIDevice currentDevice] currentModel]

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define imageName(imageName) [UIImage imageNamed:imageName]

#define    WINDOW_WIDTH             [UIScreen mainScreen].applicationFrame.size.width

#define    WINDOW_HEIGHT            [UIScreen mainScreen].applicationFrame.size.height

#define textColor(r1,g1,b1) [UIColor colorWithRed:r1/255.0 green:g1/255.0 blue:b1/255.0 alpha:1.0]

#define AlertViewNetwork {        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Network not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];[alertView show];}

#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show];}

//#define DisplayAlertDelegate(msg,tag) {         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];[alertView setTag:tag];[alertView show];}

#define PushNormal(ClassName,strClassName) {   ClassName *objClass = [[ClassName alloc] initWithNibName:[Common isAppRunningOn:strClassName] bundle:nil]; [self.navigationController pushViewController:objClass animated:YES];}

#define PushFromSlide(ClassName,strClassName) {   ClassName *objClass = [[ClassName alloc] initWithNibName:[Common isAppRunningOn:strClassName] bundle:nil];       UINavigationController *objNavController = self.menuContainerViewController.centerViewController;NSArray *controllers = [NSArray arrayWithObject:objClass];objNavController.viewControllers = controllers;}

#define PopToback {[self.navigationController popViewControllerAnimated:YES];}

#define PushNormalWithValues(ClassName,strClassName,objClass)    ClassName *objClass = [[ClassName alloc] initWithNibName:[Common isAppRunningOn:strClassName] bundle:nil];

#define Push(objClass) [self.navigationController pushViewController:objClass animated:YES];


#define Animation(duration,viewobj,x,y,w,h)         [UIView beginAnimations:nil context:nil];[UIView setAnimationDuration:duration];viewobj.frame = CGRectMake(x, y, w, h);[UIView commitAnimations];

#define ViewPosition(viewobj,x,y,w,h)     viewobj.frame = CGRectMake(x, y, w, h);

#define imageName(imageName) [UIImage imageNamed:imageName]

#define Color(r1,g1,b1) [UIColor colorWithRed:r1/255.0 green:g1/255.0 blue:b1/255.0 alpha:1.0]

#define Font(name,sizefont) [UIFont fontWithName:name size:sizefont]

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

//////// Database macros ////////
//
//#define db_Name                     @"SCS_DB.rdb"
//
//#define tbl_Friends                 @"tblFriends"
//#define c_Friends_i_No              @"i_No"
//#define c_Friends_t_FriendId        @"t_FriendId"
//#define c_Friends_t_lastName        @"t_lastName"
//#define c_Friends_t_firstName       @"t_firstName"
//#define c_Friends_t_imgLink         @"t_imgLink"
//#define c_Friends_t_UserName        @"t_UserName"
//
//#define tbl_UserInfo                @"tblUserInfo"
//#define c_UserInfo_i_No             @"i_No"
//#define c_UserInfo_t_name           @"t_name"
//#define c_UserInfo_t_email          @"t_email"
//#define c_UserInfo_t_birthday       @"t_birthday"
//#define c_UserInfo_t_gender         @"t_gender"
//#define c_UserInfo_t_location       @"t_location"
//#define c_UserInfo_t_fb_user_id     @"t_fb_user_id"
//
//////// Database macros ////////