//
//  ListingTableCell.h
//
//  Created by Ashley Templeman on 18/10/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *extraLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
