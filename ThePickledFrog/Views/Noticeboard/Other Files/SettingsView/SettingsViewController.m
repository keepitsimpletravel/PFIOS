//
//  SearchViewController.m
//
//
//  Created by abcd on 24/09/16.
//  Copyright © 2016 . All rights reserved.
//

#import "SettingsViewController.h"

#import "StaticClass.h"
#import "Singleton.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Reachability.h"

@interface SettingsViewController ()
@end

NSInteger isNotify;

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    btnLogout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnLogout.layer.borderWidth = 1.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([[StaticClass retrieveFromUserDefaults:@"isNotify"] integerValue] == 0) {
        [switchObj setOn:YES];;
        isNotify = 0;
    }
    else{
        [switchObj setOn:NO];
        isNotify = 1;
        
    }
}

-(IBAction)btnSwitchClick:(id)sender
{
    if (switchObj.on == YES) {
        isNotify = 1;
        [switchObj setOn:NO];
    }
    else{
        isNotify = 0;
        [switchObj setOn:YES];

    }
    [self setNotificaiotn];
}

-(void)setNotificaiotn
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        // No internet
        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl = [NSString stringWithFormat:@"%@setting.php?userid=%@&notify=%ld&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"],(long)isNotify];
        
        NSURL *url=[NSURL URLWithString:strUrl];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(setNotirequestFinished:)];
        [request setDidFailSelector:@selector(setNotirequestFinishedFail:)];
        [request startAsynchronous];
    }
}

- (void)setNotirequestFinished:(ASIHTTPRequest *)request
{
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
        }
    }
    @catch (NSException *exception) {
    }
    
}

- (void)setNotirequestFinishedFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnLoboutClick:(id)sender
{
    [StaticClass saveToUserDefaults:@"-1" :@"UID"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
    [super touchesBegan:touches withEvent:event];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
