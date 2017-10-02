//
//  ZoomViewController
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//
#import "ZoomViewController.h"
@interface ZoomViewController ()

@end

@implementation ZoomViewController
//@synthesize imageObj,scrollObj,urlStr;
@synthesize imageObj, urlStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
//    self.scrollObj.minimumZoomScale=0.5;
    
//    self.scrollObj.maximumZoomScale=6.0;
    
//    self.scrollObj.contentSize=CGSizeMake(screenWidth, screenHeight);
    
//    self.scrollObj.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    imageObj.imageURL = self.urlStr;
    imageObj.contentMode = UIViewContentModeScaleAspectFit;
   // self.imageObj.center = self.scrollObj.center;
    self.navigationController.tabBarController.tabBar.hidden = YES;

}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return self.imageObj;
//}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    UIView *subView = [scrollView.subviews objectAtIndex:0];
//    
//    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//    
//    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                 scrollView.contentSize.height * 0.5 + offsetY);
//}

//- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
//    
//    CGRect zoomRect;
//    
//    // The zoom rect is in the content view's coordinates.
//    
//    // At a zoom scale of 1.0, it would be the size of the
//    
//    // imageScrollView's bounds.
//    
//    // As the zoom scale decreases, so more content is visible,
//    
//    // the size of the rect grows.
//    zoomRect.size.height = scrollView.frame.size.height / scale;
//    
//    zoomRect.size.width  = scrollView.frame.size.width  / scale;
//    
//    self.scrollObj.contentSize=CGSizeMake(zoomRect.size.width, zoomRect.size.height);
//    
//    // choose an origin so as to get the right center.
//    
//    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
//    
//    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
//   
//    return zoomRect;
//}

-(IBAction)btnBackClick:(id)sender
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

@end
