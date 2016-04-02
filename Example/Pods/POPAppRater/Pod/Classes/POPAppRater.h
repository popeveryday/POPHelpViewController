//
//  POPAppRater.h
//  Pods
//
//  Created by Trung Pham Hieu on 4/2/16.
//
//

#import <Foundation/Foundation.h>

@interface POPAppRater : NSObject<UIAlertViewDelegate>

+ (instancetype)instance;

@property (nonatomic) NSInteger counterTimes;
@property (nonatomic) NSString* lastRateAction;
@property (nonatomic) NSString* appID;

+(void) resetAll;
+(NSString*) showRaterWithAppID:(NSString*) appID appName:(NSString*)appName maxCounterToAlert:(NSInteger) maxAlertCounter maxCounterToReset:(NSInteger) maxResetCounter;
+(void) rateAppID:(NSString*) appID;
+(BOOL) isCounterTimesAt:(NSString*)counter;

@end