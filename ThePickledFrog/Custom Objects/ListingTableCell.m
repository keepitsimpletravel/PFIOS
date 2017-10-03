//
//  ListingTableCell.m
//
//  Created by Ashley Templeman on 18/10/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "ListingTableCell.h"

@implementation ListingTableCell
@synthesize nameLabel = _nameLabel;
@synthesize extraLabel = _extraLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end