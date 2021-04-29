//
//  HelpViewController.m
//  Pods
//
//  Created by Trung Pham Hieu on 4/2/16.
//
//

#import "POPHelpViewController.h"
#import "POPLib.h"
#import "UIImageView+AFNetworking.h"
#import "POPAppRater.h"
#import "POPOrientationNavigationVC.h"


@interface POPHelpViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation POPHelpViewController
{
    NSMutableArray* views;
    UIBarButtonItem* doneBtn;
    
    NSInteger currentPageIndex;
    NSInteger nextPageIndex;
}

+(POPHelpViewController*) presentHelpFromViewController:(UIViewController*)fromVC iPhoneDatasourceFile:(NSString*)iPhonefile iPadDatasourcefile:(NSString*)iPadfile isRequireReviewFullHelp:(BOOL)isRequireReviewFullHelp
{
    return [self presentHelpFromViewController:fromVC iPhoneDatasource:[FileLib readFile:iPhonefile] iPadDatasource:[FileLib readFile:iPadfile] isRequireReviewFullHelp:isRequireReviewFullHelp];
}

+(POPHelpViewController*) presentHelpFromViewController:(UIViewController*)fromVC iPhoneDatasource:(NSString*)iphoneDs iPadDatasource:(NSString*)ipadDs isRequireReviewFullHelp:(BOOL)isRequireReviewFullHelp
{
    POPHelpViewController* helpvc = [[POPHelpViewController alloc] initWithIphoneDatasource:iphoneDs iPadDatasource:ipadDs];
    helpvc.isRequireReviewFullHelp = isRequireReviewFullHelp;
    helpvc.isPresentedView = YES;
    
    POPOrientationNavigationVC* nav = [[POPOrientationNavigationVC alloc] initWithRootViewController:helpvc];
    
    [fromVC presentViewController:nav animated:YES completion:nil];
    
    return helpvc;
}



-(id)init
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithIphoneDatasourceFile:(NSString*)iphonefile iPadDatasourcefile:(NSString*)ipadfile
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
        self.iPhoneHelpDatasource = [FileLib readFile:iphonefile];
        self.iPadHelpDatasource = [FileLib readFile:ipadfile];
    }
    return self;
}

-(id)initWithIphoneDatasource:(NSString*)iphoneDs iPadDatasource:(NSString*)ipadDs
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
        self.iPhoneHelpDatasource = iphoneDs;
        self.iPadHelpDatasource = ipadDs;
    }
    return self;
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void) actionDone:(id)sender
{
    if (self.isPresentedView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void) viewWillAppear:(BOOL)animated{
    [self initDatasource];
}

-(void) initDatasource
{
    doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    if (!_isRequireReviewFullHelp) self.navigationItem.rightBarButtonItem = doneBtn;
    [self.navigationItem setHidesBackButton:YES];
    
    
    self.delegate = self;
    self.dataSource = self;
    
    
    views = [[NSMutableArray alloc] init];
    
    NSString* datasource = GC_Device_IsIpad ? _iPadHelpDatasource : _iPhoneHelpDatasource;
    
    NSInteger index = 0;
    for (NSString* page in [datasource componentsSeparatedByString:@"||"])
    {
        if(![StringLib isValid:page]) continue;
        [views addObject:[self buildViewControllerWithContent:page index:index]];
        index++;
    }
    
    
    [self setViewControllers:@[[views objectAtIndex:_defaultStartPageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:Nil];
    
    self.title = ((UIViewController*) [views objectAtIndex:_defaultStartPageIndex] ).title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UIViewController*) buildViewControllerWithContent:(NSString*)content index:(NSInteger)index
{
    UIViewController* viewcontroller = [[UIViewController alloc] init];
    viewcontroller.view.frame = self.view.frame;
    viewcontroller.view.backgroundColor = [UIColor blackColor];
    viewcontroller.view.tag = index;
    
    
    UIScrollView* view = [[UIScrollView alloc] init];
    view.frame = viewcontroller.view.frame;
    
    
    BOOL isFlowLayout = !_isDefaultCenterLayout; //IF NO -> middle vertical content
    CGFloat spacing = _defaultSpacing != 0 ? _defaultSpacing : 10;
    CGFloat centerx = view.center.x;
    CGFloat centery = 0;
    NSString* type, *value;
    
    content = [StringLib trim:content];
    
    for (NSString* line in [content componentsSeparatedByString:@"|"] ) {
        if(![StringLib isValid:line]) continue;
        
        Hashtable* options = [StringLib deparseString: [StringLib trim:line] ];
        
        type = [StringLib trim:[options hashtable_GetValueForKey:@"type"]];
        value = [StringLib trim:[options hashtable_GetValueForKey:@"value"]];
        
        //image type
        if ([type isEqualToString:@"image"])
        {
            
            NSString* scale = [options hashtable_GetValueForKey:@"scale"];
            float scalevalue = scale != nil ? scale.floatValue : 1;
            
            UIImageView* image;
            
            if ( [StringLib indexOf:@"HTTP://" inString:[value uppercaseString]] == 0 )
            {
                image = ImageViewWithImagename(@"CommonLib.bundle/FileExplorerLoading");
                
                [image setContentMode: UIViewContentModeScaleAspectFit];
                
                NSString* width = [options hashtable_GetValueForKey:@"width"];
                NSString* height = [options hashtable_GetValueForKey:@"height"];
                
                image.frame = CGRectMake(0,0, (width != nil ? width.floatValue/2 : 100) * scalevalue, (height != nil ? height.floatValue/2 : 100) * scalevalue);
                
                [image setImageWithURL:[NSURL URLWithString:value] placeholderImage: image.image ];
                
            }else{
                
                image = ImageViewWithImagename(value);
                image.frame = CGRectMake(0,0,image.image.size.width*scalevalue, image.image.size.height*scalevalue);
                image.center = CGPointMake(0, 0);
            }
            
            
            NSString* newspacing = [options hashtable_GetValueForKey:@"spacing"];
            if (newspacing != nil) {
                centery += newspacing.floatValue;
            }
            
            centery += (image.frame.size.height/2) + spacing;
            image.center = CGPointMake(centerx, centery);
            centery += (image.frame.size.height/2);
            
            NSString* url = [options hashtable_GetValueForKey:@"url"];
            NSString* urlappid = [options hashtable_GetValueForKey:@"urlappid"];
            if ( url != nil || urlappid != nil )
            {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: url != nil ? @selector(handlelTapUrl:) : @selector(handlelTapRateApp:) ];
                tap.cancelsTouchesInView = YES;
                tap.numberOfTapsRequired = 1;
                
                image.userInteractionEnabled = YES;
                [image addGestureRecognizer:tap];
                image.accessibilityHint = url != nil ? url : urlappid;
            }
            
            [view addSubview:image];
        }
        
        //text
        if ([type isEqualToString:@"text"])
        {
            UILabel* label = [[UILabel alloc] init];
            label.text = value;
            label.numberOfLines = 1000;
            
            NSString* url = [options hashtable_GetValueForKey:@"url"];
            NSString* urlappid = [options hashtable_GetValueForKey:@"urlappid"];
            if ( url != nil || urlappid != nil )
            {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: url != nil ? @selector(handlelTapUrl:) : @selector(handlelTapRateApp:) ];
                tap.cancelsTouchesInView = YES;
                tap.numberOfTapsRequired = 1;
                
                label.userInteractionEnabled = YES;
                [label addGestureRecognizer:tap];
                label.accessibilityHint = url;
            }
            
            NSString* align = [options hashtable_GetValueForKey:@"align"];
            if (align != nil)
            {
                label.textAlignment = [[align uppercaseString] isEqualToString:@"CENTER"] ? NSTextAlignmentCenter : [[align uppercaseString] isEqualToString:@"LEFT"] ? NSTextAlignmentLeft : [[align uppercaseString] isEqualToString:@"RIGHT"] ? NSTextAlignmentRight : NSTextAlignmentJustified ;
            }else{
                label.textAlignment = NSTextAlignmentCenter;
            }
            
            
            
            NSString* fontsize = [options hashtable_GetValueForKey:@"fontsize"];
            if (fontsize != nil) {
                label.font = [UIFont fontWithName:label.font.fontName size:fontsize.floatValue];
            }else if(_defaultFontSize > 0){
                label.font = [UIFont fontWithName:label.font.fontName size:_defaultFontSize];
            }
            
            NSString* fontstyle = [options hashtable_GetValueForKey:@"fontstyle"];
            if (fontstyle != nil)
            {
                label.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-%@", label.font.fontName, fontstyle] size:label.font.pointSize];
            }
            
            NSString* fontname = [options hashtable_GetValueForKey:@"fontname"];
            if (fontname != nil)
            {
                label.font = [UIFont fontWithName:fontname size:label.font.pointSize];
            }else if( [StringLib isValid:_defaultFontName] ){
                label.font = [UIFont fontWithName:_defaultFontName size:label.font.pointSize];
            }
            
            NSString* color = [options hashtable_GetValueForKey:@"color"];
            if (color != nil)
            {
                label.textColor = [CommonLib colorFromHexString:color alpha:1];
            }else if(_defaultForeColor != nil){
                label.textColor = _defaultForeColor;
            }
            
            NSString* newspacing = [options hashtable_GetValueForKey:@"spacing"];
            if (newspacing != nil) {
                centery += newspacing.floatValue;
            }
            
            CGFloat width = self.view.frame.size.width - 20;
            
            CGRect r = [value boundingRectWithSize:CGSizeMake( width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : label.font }
                                           context:nil];
            label.frame = CGRectMake(0, 0, width, r.size.height);
            
            
            centery += (label.frame.size.height/2) + spacing;
            label.center = CGPointMake(centerx, centery);
            centery += (label.frame.size.height/2);
            
            [view addSubview:label];
        }
        
        //title whole page
        if ([type isEqualToString:@"title"]) {
            viewcontroller.title = value;
            
            NSString* layout = [options hashtable_GetValueForKey:@"layout"];
            if (layout != nil) {
                isFlowLayout = [layout isEqualToString:@"flow"];
            }
        }
    }
    
    [viewcontroller.view addSubview:view];
    view.contentSize = CGSizeMake(viewcontroller.view.frame.size.width, centery + 20);
    
    if (isFlowLayout) {
        view.frame = CGRectMake(0, 66, viewcontroller.view.frame.size.width, viewcontroller.view.frame.size.height - 100);
    }else{
        view.frame = CGRectMake(0, 0, view.contentSize.width, view.contentSize.height);
        view.center = viewcontroller.view.center;
    }
    
    return viewcontroller;
}

- (void) handlelTapUrl:(UIGestureRecognizer *)gestureRecognizer {
    UIView* view = gestureRecognizer.view;
    NSString* url = view.accessibilityHint;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void) handlelTapRateApp:(UIGestureRecognizer *)gestureRecognizer {
    UIView* view = gestureRecognizer.view;
    NSString* appid = view.accessibilityHint;
    [POPAppRater rateAppID:appid];
}



#pragma Page View Controller functions
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(!completed) return;
    currentPageIndex = nextPageIndex;
    self.title = [views[currentPageIndex] title];
    
    if (_isRequireReviewFullHelp && currentPageIndex == views.count-1) {
        self.navigationItem.rightBarButtonItem = doneBtn;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for (UIViewController* view in pendingViewControllers) {
        nextPageIndex = view.view.tag;
    }
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [views indexOfObject:viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [views objectAtIndex:index];
}

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [views indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == views.count) {
        return nil;
    }
    return [views objectAtIndex:index];
}

//HIDE CAI PAGE INDEX thi mo phan nay ra
-(NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return views.count;
}

-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return _defaultStartPageIndex;
}

#pragma manage orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == _isLandscapeView ? UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return _isLandscapeView ? NO : YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    return _isLandscapeView ? UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationMaskPortrait;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return _isLandscapeView ? UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight :  UIInterfaceOrientationPortrait;
}

@end
