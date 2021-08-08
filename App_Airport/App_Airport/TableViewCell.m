//
//  TableViewCell.m
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 5.0, 100, 30)];
        [self.contentView addSubview:_cityImageView];
    }
    return self;
}

- (void)configure:(UIImage *)cityImage {
    _cityImageView.image = cityImage;
}

@end
