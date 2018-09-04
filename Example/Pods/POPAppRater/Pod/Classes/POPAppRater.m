//
//  POPAppRater.m
//  Pods
//
//  Created by Trung Pham Hieu on 4/2/16.
//
//

#import "POPAppRater.h"
#import "POPLib.h"

#define AppRateManager_counter @"AppRateManager_counter"
#define AppRateManager_action @"AppRateManager_action"

@implementation POPAppRater

+ (instancetype)instance
{
    static POPAppRater *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[POPAppRater alloc] init];
    });
    return instance;
}

+(void)resetAll{
    [[POPAppRater instance] resetAll];
}

+(NSString*)showRaterWithAppID:(NSString*) appID appName:(NSString*)appName maxCounterToAlert:(NSInteger) maxAlertCounter maxCounterToReset:(NSInteger) maxResetCounter
{
    return [[POPAppRater instance] ShowRaterWithAppID:appID appName:appName maxCounterToAlert:maxAlertCounter maxCounterToReset:maxResetCounter];
}

+(void) rateAppID:(NSString*) appID{
    NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        templateReviewURL = @"itms-apps://itunes.apple.com/app/idAPP_ID";
    
    
    
    NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", appID]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}



//1-5,7
+(BOOL) isCounterTimesAt:(NSString*)counter
{
    NSMutableArray* listCounter = [[NSMutableArray alloc] init];
    
    NSArray* parts = [counter componentsSeparatedByString:@","];
    for (NSString* one in parts) {
        if ([StringLib contains:@"-" inString:one]) {
            NSArray* oneparts = [one componentsSeparatedByString:@"-"];
            NSInteger from = [oneparts[0] integerValue];
            NSInteger to = oneparts.count > 1 ? [oneparts[1] integerValue] : 0;
            if (from == 0 || to == 0 || from >= to) break;
            for (NSInteger i = from; i <= to; i++) {
                [listCounter addObject:[NSString stringWithFormat:@"%ld", (long)i]];
            }
            
        }else{
            [listCounter addObject:[StringLib trim:one]];
        }
    }
    
    for (NSString* one in listCounter) {
        if ([POPAppRater instance].counterTimes % one.integerValue == 0) {
            return true;
        }
    }
    
    return false;
}

//======================================

-(id) init{
    if (self = [super init]) {
        self.counterTimes = [[CommonLib getAppPreference:AppRateManager_counter defaultValue: [NSNumber numberWithInt:0] ] integerValue];
        self.lastRateAction = [CommonLib getAppPreference:AppRateManager_action defaultValue: @"NONE" ];
    }
    return self;
}


-(void)setCounterTimes:(NSInteger)counterTimes
{
    _counterTimes = counterTimes;
    [CommonLib setAppPreference:AppRateManager_counter value:[NSNumber numberWithInteger:counterTimes]];
}

-(void)setLastRateAction:(NSString *)lastRateAction
{
    _lastRateAction = lastRateAction;
    [CommonLib setAppPreference:AppRateManager_action value:lastRateAction];
}

-(void)resetAll{
    self.lastRateAction = @"NONE";
    self.counterTimes = 0;
}


-(NSString*)ShowRaterWithAppID:(NSString*) appID appName:(NSString*)appName maxCounterToAlert:(NSInteger) maxAlertCounter maxCounterToReset:(NSInteger) maxResetCounter
{
    self.appID = appID;
    self.counterTimes = self.counterTimes + 1;
    
    if (self.counterTimes < maxAlertCounter) {
        self.lastRateAction = @"NONE";
    }else if (self.counterTimes == maxAlertCounter){
        NSString* message = NSLocalizedStringFromTableInBundle(@"If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", @"AppiraterLocalizable", [NSBundle mainBundle], nil);
        message = [NSString stringWithFormat:message, appName];
        
        NSString* buttonAccept = NSLocalizedStringFromTableInBundle(@"Rate %@", @"AppiraterLocalizable", [NSBundle mainBundle], nil);
        buttonAccept = [NSString stringWithFormat:buttonAccept, appName];
        NSString* buttonLater = NSLocalizedStringFromTableInBundle(@"Remind me later", @"AppiraterLocalizable", [NSBundle mainBundle], nil);
        NSString* buttonCancel = NSLocalizedStringFromTableInBundle(@"No, Thanks", @"AppiraterLocalizable", [NSBundle mainBundle], nil);
        
        [ViewLib alertWithTitle:buttonAccept message:message fromViewController:nil callback:^(NSString *buttonTitle, NSString *alertTitle) {
            
            if ([buttonTitle isEqualToString:buttonAccept]) {
                [POPAppRater rateAppID: self.appID];
                self.lastRateAction = @"DONE";
            }else if ([buttonTitle isEqualToString:buttonAccept]) {
                [self resetAll];
            }else{
                self.lastRateAction = @"NEVER";
            }
        } cancelButtonTitle:buttonCancel otherButtonTitles:buttonAccept, buttonLater, nil];
        
    }else{
        if ([self.lastRateAction isEqualToString:@"NEVER"] && self.counterTimes >= maxResetCounter && maxResetCounter > 0 && maxResetCounter > maxAlertCounter)
        {
            [self resetAll];
        }
    }
    NSLog(@"AppRateManager: %ld-%@",(long)self.counterTimes, self.lastRateAction);
    return [NSString stringWithFormat:@"%ld-%@",(long)self.counterTimes, self.lastRateAction];
}




@end
