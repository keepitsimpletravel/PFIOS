//
//  ProfileViewController.m
//  ChatMessenger
//
//  Created by abcd on 15/11/16.
//  Copyright © 2016 ChatMessenger. All rights reserved.
//

#import "ProfileViewController.h"
#import "StaticClass.h"
#import "Singleton.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "Base64.h"

@interface ProfileViewController ()

@end
NSInteger p_photo = 0;

@implementation ProfileViewController
@synthesize profileImg;
@synthesize imagePickerController,myImageData,senderID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    settingsViewObj = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    lblName.text = [StaticClass retrieveFromUserDefaults:@"NAME"];
    if (p_photo == 0) {
        [self GetProfile];
    }
}

//GetProfile
-(void)GetProfile
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
        NSString *strUrl;
        if([self.senderID isEqualToString:@""])
        {
            strUrl=[NSString stringWithFormat:@"%@getUser.php?userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"]];
        }
        else{
            strUrl=[NSString stringWithFormat:@"%@getUser.php?userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],self.senderID];
        }
        
        NSURL *url=[NSURL URLWithString:strUrl];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(GetProfilerequestFinished:)];
        [request setDidFailSelector:@selector(GetProfilerequestFail:)];
        [request startAsynchronous];
    }
}

- (void)GetProfilerequestFinished:(ASIHTTPRequest *)request
{
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            NSDictionary *userData = [dict valueForKey:@"user_data"];
            profileImg.imageURL = [NSURL URLWithString:[userData valueForKey:@"image"]];
            lblName.text = [userData valueForKey:@"name"];
            btnUpdate.hidden = YES;
            btnSettings.hidden = YES;
            if([[StaticClass retrieveFromUserDefaults:@"UID"] isEqualToString:[userData valueForKey:@"userID"]])
            {
                btnUpdate.hidden = NO;btnSettings.hidden = NO;
            }
        }
    }
    @catch (NSException *exception) {
    }

}

- (void)GetProfilerequestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//AddPhoto
-(IBAction)btnAddPhotoClick
{
    p_photo = 1;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *photoAlert = [[UIAlertView alloc]initWithTitle:@"Select Photo" message:@"Select Photo from Camera or Library" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Capture",@"Choose from Library",@"Cancel",nil];
        photoAlert.tag =1;
        [photoAlert show];
    }
    else
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.myImageData = UIImageJPEGRepresentation(selectedImage,1.0);
    [self sendPhoto];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1)
    {
        if (buttonIndex == 0) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        if (buttonIndex == 1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)sendPhoto
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
        NSString *strUrl=[NSString stringWithFormat:@"%@addProfile.php",[[Singleton sharedSingleton]getBaseURL]];
        NSURL *url=[NSURL URLWithString:strUrl];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[StaticClass retrieveFromUserDefaults:@"UID"] forKey:@"userID"];
        [Base64 initialize];
        NSString *str = @"";
        if (self.myImageData != nil) {
            str = [Base64 encode:self.myImageData];
        }
        [request setPostValue:str forKey:@"image"];
        [request setPostValue:@"5a14ec5b310164f2dfe49e86b06124a" forKey:@"key"];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(onSendPhotoSuccess:)];
        [request setDidFailSelector:@selector(onSendPhotoSuccessFail:)];
        [request startAsynchronous];
    }
}

- (void)onSendPhotoSuccess:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
        p_photo =0;
        [self.view.window makeToast:[dict valueForKey:@"msg"]];
        self.myImageData = nil;
        [self GetProfile];
    }
    
    else{
        [self.view makeToast:[dict valueForKey:@"msg"]];
    }
}

- (void)onSendPhotoSuccessFail:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"Internet-anslutning inte finns!"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSettingsClick:(id)sender
{
    [self.navigationController pushViewController:settingsViewObj animated:YES];
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
