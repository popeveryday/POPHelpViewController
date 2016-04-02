//
//  HelpViewController.h
//  Pods
//
//  Created by Trung Pham Hieu on 4/2/16.
//
//

#import <UIKit/UIKit.h>


@interface POPHelpViewController : UIPageViewController

@property (nonatomic) UIColor* defaultForeColor;
@property (nonatomic) float defaultFontSize;
@property (nonatomic) NSString* defaultFontName;
@property (nonatomic) float defaultSpacing;
@property (nonatomic) BOOL isDefaultCenterLayout;
@property (nonatomic) NSInteger defaultStartPageIndex;
@property (nonatomic) BOOL isLandscapeView;

//yes -> if want user view all slide before press Done
@property (nonatomic) BOOL isRequireReviewFullHelp;

@property (nonatomic) NSString* iPhoneHelpDatasource;
@property (nonatomic) NSString* iPadHelpDatasource;

//for dismiss view
@property (nonatomic) BOOL isPresentedView;

-(id)initWithIphoneDatasource:(NSString*)iphoneDs iPadDatasource:(NSString*)ipadDs;
-(id)initWithIphoneDatasourceFile:(NSString*)iphonefile iPadDatasourcefile:(NSString*)ipadfile;

+(POPHelpViewController*) presentHelpFromViewController:(UIViewController*)fromVC iPhoneDatasourceFile:(NSString*)iPhonefile iPadDatasourcefile:(NSString*)iPadfile isRequireReviewFullHelp:(BOOL)isRequireReviewFullHelp;

+(POPHelpViewController*) presentHelpFromViewController:(UIViewController*)fromVC iPhoneDatasource:(NSString*)iphoneDs iPadDatasource:(NSString*)ipadDs isRequireReviewFullHelp:(BOOL)isRequireReviewFullHelp;

@end


/*
 type=title&value=Welcome&layout=center|
 type=image&value=iMBR_logo&scale=0.5|
 type=text&fontsize=30&spacing=30&color=ffffff&value=Welcome|
 type=text&spacing=30&color=ffffff&value=First steps to Sync and
 View your backup messages.||
 
 
 
 type=title&value=iPhone SMS Backup File|
 type=image&value=iMBR_iTunes-backup&scale=0.5|
 type=text&color=ffffff&spacing=10&value=Connect your iPhone to your Mac or PC and open iTunes.
 Select your iPhone.
 Click "Back Up Now" in "Summary" tab.|
 type=image&spacing=30&value=iMBR_Backup-file&scale=0.5|
 type=text&color=ffffff&spacing=10&value=Go to backup location on your computer:|
 type=text&color=ffffff&fontsize=10&value=Mac:
 ~/Library/Application Support/MobileSync/Backup/
 
 Windows XP:
 C:\Documents and Settings\[your username]\
 Application Data\Apple Computer\MobileSync\Backup\
 
 Windows 7 or Windows 8:
 C:\Users\user\AppData\Roaming\Apple Computer\MobileSync\Backup|
 type=text&color=ffffff&value=Choose one backup folder,
 for example:|
 type=text&color=ffffff&fontsize=10&value=9182749a9879a8798a798e98798798f9879877c98798|
 type=text&color=ffffff&value=Open that directory and look for the following filename:|
 type=text&color=ffffff&fontsize=10&value=3d0d7e5fb2ce288813306e4d4636395e047a3d28||
 
 
 
 type=title&value=iTunes Upload|
 type=image&value=iMBR_Sync&scale=0.5|
 type=text&color=ffffff&spacing=10&value=Connect your iPhone to your Mac
 or PC using the cable.
 Open iTunes.
 Select your iPhone.
 Switch to the "Apps" tab, scroll down
 and look for iMessageBackupReader.
 Transfer your file with name:|
 type=text&color=ffffff&fontsize=10&value=3d0d7e5fb2ce288813306e4d4636395e047a3d28|
 type=text&color=ffffff&value=Switch to iMessageBackupReader
 Click "Start" and then "Import from Itune".||
 
 
 
 type=title&value=Wifi Upload|
 type=image&value=iMBR_Sync-wifi&scale=0.5|
 type=text&color=ffffff&spacing=10&value=Connect your iPhone to the same
 network as your Mac or PC.|
 type=image&spacing=30&value=iMBR_Sync-wifi-2&scale=0.5|
 type=text&color=ffffff&spacing=10&value=Switch to iMessageBackupReader
 Click "Start" and then "Wifi Upload".
 Enter the URL to the web browser
 and upload your file with name:|
 type=text&color=ffffff&fontsize=10&value=3d0d7e5fb2ce288813306e4d4636395e047a3d28||
 
 
 type=title&value=Usage|
 type=image&scale=0.75&value=iMBR_Search|
 type=text&color=ffffff&spacing=10&value=Search contact's name or contact's number or message content.
 Type search text in the search bar on top of conversation list.|
 type=image&scale=0.75&spacing=30&value=iMBR_Usage2|
 type=text&color=ffffff&spacing=10&value=Copy contact's detail or message.
 Touch and hold to on contact's name or message.
 Tap "Copy" to copy text to clipboard.|
 type=image&scale=0.75&spacing=30&value=iMBR_Usage|
 type=text&color=ffffff&spacing=10&value=Delete a conversation or message, swipe left and click "Delete".||
 
 
 type=title&value=The End&layout=center|
 type=image&value=iMBR_logo&scale=0.5|
 type=text&fontsize=20&spacing=30&color=ffffff&value=iMessage Backup Reader|
 type=text&spacing=20&color=ffffff&value=Free software developed by Poptato.com
 We hope you'll love it.||
 */