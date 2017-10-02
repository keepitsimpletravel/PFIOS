//
//  SendViewController.m
//  ChatMessenger
//
//  Created by abcd on 24/11/16.
//  Copyright © 2016 ChatMessenger. All rights reserved.
//

#import "SendViewController.h"
#import "UIView+Toast.h"
#import "Singleton.h"
#import "StaticClass.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    txtMessage.layer.cornerRadius = 5.0; txtMessage.layer.masksToBounds = YES;
    txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtMessage.layer.borderWidth = 1.0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    txtMessage.text = @"";
    [txtMessage resignFirstResponder];
}

-(IBAction)btnSendClick:(id)sender
{
    [txtMessage resignFirstResponder];
    if ([[txtMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self.view.window makeToast:@"Please enter message"];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl=[NSString stringWithFormat:@"%@sendNotification.php?receiverID=%@&senderID=%@&msg=%@&name=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"RECEIVER"],[StaticClass retrieveFromUserDefaults:@"UID"],txtMessage.text,[StaticClass retrieveFromUserDefaults:@"NAME"]];
        NSURL *url=[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(onSendMessageSuccess:)];
        [request setDidFailSelector:@selector(onSendMessageSuccessFail:)];
        [request startAsynchronous];
    }
}

- (void)onSendMessageSuccess:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
        txtMessage.text = @"";
        [self.view.window makeToast:[dict valueForKey:@"msg"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.view makeToast:[dict valueForKey:@"msg"]];
    }
}

- (void)onSendMessageSuccessFail:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"Internet-anslutning inte finns!"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
