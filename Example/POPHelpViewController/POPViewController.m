//
//  POPViewController.m
//  POPHelpViewController
//
//  Created by popeveryday on 04/02/2016.
//  Copyright (c) 2016 popeveryday. All rights reserved.
//

#import "POPViewController.h"
#import <POPHelpViewController/POPHelpViewController.h>

@interface POPViewController ()<UIActionSheetDelegate>

@end

@implementation POPViewController
{
    UILabel* label;
    BOOL isFirstDisplayView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstDisplayView = YES;
    
    label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = @"Display Help";
    label.numberOfLines = 100;
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionHelp:)];
    [label addGestureRecognizer:tap];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isFirstDisplayView) return;
    isFirstDisplayView = NO;
    
    BOOL isFirstTimeStartApp = [[self getAppPreference:@"FirstTime" defaultValue:@"0"] isEqualToString:@"0"];
    [self setAppPreference:@"FirstTime" value:@"1"];
    
    if(isFirstTimeStartApp) [self displayHelp:isFirstTimeStartApp];
}

-(void)displayHelp:(BOOL)isFirstTimeStartApp
{
    NSString* iPhoneHelpPath = [self getEmbedResourcePathWithFilename:@"help.txt"];
    NSString* iPadHelpPath = [self getEmbedResourcePathWithFilename:@"help_ipad.txt"];
    
    [POPHelpViewController presentHelpFromViewController:self iPhoneDatasourceFile:iPhoneHelpPath iPadDatasourcefile:iPadHelpPath isRequireReviewFullHelp:isFirstTimeStartApp];
    
}

-(void) actionHelp:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Help Startup" otherButtonTitles:@"Show Help (First Time)", @"Show Help Normal", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Reset Help Startup"])
    {
        [self setAppPreference:@"FirstTime" value:@"0"];
    }
    else if ([buttonTitle isEqualToString:@"Show Help (First Time)"])
    {
        [self displayHelp:YES];
    }
    else if ([buttonTitle isEqualToString:@"Show Help Normal"])
    {
        [self displayHelp:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAppPreference:(NSString*) key value:(id)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}
-(id)getAppPreference:(NSString*)key defaultValue:(id)defaultValue{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id value = [userDefaults objectForKey:key];
    
    if( value == nil && defaultValue != nil){
        [self setAppPreference:key value:defaultValue];
        return defaultValue;
    }
    
    return value;
}

-(NSString*) getEmbedResourcePathWithFilename:(NSString*) filename
{
    return [[NSBundle mainBundle] pathForResource:[[filename lastPathComponent] stringByDeletingPathExtension] ofType: [[filename lastPathComponent] pathExtension]];
}


@end
