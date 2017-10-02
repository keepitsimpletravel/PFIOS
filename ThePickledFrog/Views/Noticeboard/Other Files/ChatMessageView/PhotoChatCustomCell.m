//

#import "PhotoChatCustomCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation PhotoChatCustomCell
@synthesize imageObj,lblName,lblBG;
@synthesize lblMessage,lblTime,photo,btnPhoto,btnReport;

-(void)drawImageView {
    
	imageObj =[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"image.png"]];
	imageObj.frame = CGRectMake(0.0f, 25.0f,50.0f,50.0f);
    imageObj.layer.masksToBounds = YES;
    imageObj.contentMode = UIViewContentModeScaleToFill;
   // imageObj.layer.cornerRadius = 7.0;
    //[imageObj.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
   // [imageObj.layer setBorderWidth: 1.0];
	[self.contentView addSubview:imageObj];
}


@end
