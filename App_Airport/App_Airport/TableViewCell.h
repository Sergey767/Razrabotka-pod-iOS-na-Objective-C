//
//  TableViewCell.h
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cityImageView;

- (void)configure:(UIImage *)cityImage;

@end

NS_ASSUME_NONNULL_END
