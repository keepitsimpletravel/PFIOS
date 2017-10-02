//
//  HomeViewController.m
//  CrewFinder
//
//  Created by abcd on 21/01/16.
//  Copyright (c) 2016 CrewFinder. All rights reserved.
//

#import "BrowseProfileViewController.h"
#import "BrowseMemberCustomCell.h"
#import "Singleton.h"
#import "StaticClass.h"
#import "ASIFormDataRequest.h"

@interface BrowseProfileViewController ()

@end
@implementation BrowseProfileViewController
@synthesize tableViewobj,jobArray,txtSearch,subJobArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    jobArray = [[NSMutableArray alloc]init];
    subJobArray = [[NSMutableArray alloc]init];
    
    self.tableViewobj.rowHeight = 70.0f;
    [txtSearch addTarget:self action:@selector(ifSearchTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    sendViewObj = [[SendViewController alloc]initWithNibName:@"SendViewController" bundle:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    txtSearch.text = @"";
    [txtSearch resignFirstResponder];
    [self getAllMember];
}

-(void)getAllMember
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl=[NSString stringWithFormat:@"%@activeUser.php?userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"]];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestUserFinished:)];
    [request setDidFailSelector:@selector(requestUserFail:)];
    [request startAsynchronous];
}

- (void)requestUserFinished:(ASIHTTPRequest *)request
{
    [jobArray removeAllObjects];
    [subJobArray removeAllObjects];
    jobArray = [[NSMutableArray alloc]init];
    subJobArray = [[NSMutableArray alloc]init];
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        //Frnd
        NSArray *items = [dict valueForKey:@"user_data"];
        if (![items isEqual: [NSNull null]]) {
            for (NSDictionary *d in items) {
                if (![[d valueForKey:@"userID"] isEqual: [NSNull null]]) {
                    
                    NSMutableDictionary *yourMutableDictionary = [[NSMutableDictionary alloc] init];
                    [yourMutableDictionary setObject:[d valueForKey:@"name"] forKey:@"name"];
                    [yourMutableDictionary setValue:[d valueForKey:@"image"] forKey:@"image"];
                    [yourMutableDictionary setValue:[d valueForKey:@"userID"] forKey:@"userID"];
                    [yourMutableDictionary setValue:@"NO" forKey:@"isSelected"];

                    [jobArray addObject:yourMutableDictionary];
                    [subJobArray addObject:yourMutableDictionary];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    [self.tableViewobj reloadData];
    lblNoData.hidden = YES;
    self.tableViewobj.hidden = NO;
    if (self.jobArray.count == 0) {
        lblNoData.hidden = NO;
        self.tableViewobj.hidden = YES;
    }
}

- (void)requestUserFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return jobArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *temp= @"BrowseMemberCustomCell";
    BrowseMemberCustomCell *cellheader = (BrowseMemberCustomCell *)[self.tableViewobj dequeueReusableCellWithIdentifier:temp];
    if (cellheader == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"BrowseMemberCustomCell" owner:self options:nil];
        cellheader = [nib objectAtIndex:0];
        cellheader.showsReorderControl = NO;
        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
        cellheader.backgroundColor=[UIColor clearColor];
        [cellheader.btnCheck addTarget:self action:@selector(btnCheckClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cellheader.btnCheck.tag = indexPath.row;
    
    cellheader.imageObj.layer.masksToBounds = YES;
    cellheader.imageObj.layer.cornerRadius = 25.0;
    
    NSDictionary *tempObj = [jobArray objectAtIndex:indexPath.row];
    cellheader.lblName.text = [tempObj valueForKey:@"name"];

    cellheader.imageObj.placeholderImage = [UIImage imageNamed:@"image.png"];
    cellheader.imageObj.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"image"]];
    if ([[tempObj valueForKey:@"isSelected"] isEqualToString:@"YES"]) {
        [cellheader.btnCheck setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else{
        [cellheader.btnCheck setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    }
    return cellheader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempObj = [jobArray objectAtIndex:indexPath.row];
    if ([[tempObj valueForKey:@"isSelected"] isEqualToString:@"YES"]) {
        [tempObj setValue:@"NO" forKey:@"isSelected"];
    }
    else{
        [tempObj setValue:@"YES" forKey:@"isSelected"];
    }
    [self.tableViewobj reloadData];
}

-(IBAction)btnCheckClick:(id)sender
{
    NSDictionary *tempObj = [jobArray objectAtIndex:[sender tag]];
    if ([[tempObj valueForKey:@"isSelected"] isEqualToString:@"YES"]) {
        [tempObj setValue:@"NO" forKey:@"isSelected"];
    }
    else{
        [tempObj setValue:@"YES" forKey:@"isSelected"];
    }
    [self.tableViewobj reloadData];
}

-(IBAction)btnSendClick:(id)sender
{
    NSString *userIdStr = @"";
    for (NSDictionary *d in self.jobArray) {
        if ([[d valueForKey:@"isSelected"] isEqualToString:@"YES"]) {
            userIdStr = [userIdStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[d valueForKey:@"userID"]]];
        }
    }
    if ([userIdStr length] > 0) {
        userIdStr = [userIdStr substringToIndex:[userIdStr length] - 1];
    }
    [StaticClass saveToUserDefaults:userIdStr:@"RECEIVER"];
    [self.navigationController pushViewController:sendViewObj animated:YES];

}

-(void)ifSearchTextFieldChanged:text
{
    [self searchAutocompleteGroup:txtSearch.text];
}

-(void)searchAutocompleteGroup:(NSString *)substring
{
    @try {
        NSString *curString;
        
        [jobArray removeAllObjects];
        
        if(![substring isEqualToString:@""] )
        {
            for(NSDictionary *obj in  self.subJobArray)
            {
                curString = [[obj valueForKey:@"search_name"] stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                substring = [substring stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
                if (substringRange.location != NSNotFound){
                    [self.jobArray addObject:obj];
                }
            }
        }
        else {
            for(NSDictionary *obj in  self.subJobArray){
                [self.jobArray addObject:obj];
            }
        }
        [self.tableViewobj  reloadData];
    }
    @catch (NSException *exception) {
        
    }
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getAllMember];
    return YES;
}

-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)didReceiveMemoryWarning {
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
