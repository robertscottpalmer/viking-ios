//
//  MainVC.h
//  Viking

#import <UIKit/UIKit.h>

@interface MainVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *tripNewImage;
@property (nonatomic, weak) IBOutlet UIImageView *myTripImage;
@property (nonatomic, weak) IBOutlet UIImageView *featuredListImage;
@property (nonatomic, weak) IBOutlet UIImageView *downloadListImage;
@property (nonatomic, weak) IBOutlet UILabel *bottomLbl;
@property (nonatomic, weak) IBOutlet UILabel *betaLbl;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) BOOL pageControlUsed;

@property (nonatomic, weak) IBOutlet UIView *facebookPostView;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *fbIndication;


- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end
