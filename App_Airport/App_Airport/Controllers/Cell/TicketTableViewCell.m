//
//  TicketTableViewCell.m
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import "TicketTableViewCell.h"

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];

@interface TicketTableViewCell()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        _placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:_dateLabel];
        
        [UIView animateWithDuration:2
                              delay:0
                            options:UIViewAnimationOptionAutoreverse
                         animations:^{
            self.priceLabel.frame = CGRectMake(10.0, 10, self.contentView.frame.size.width - 110.0, 40.0);
            [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionRepeat animations:^{
                self.airlineLogoView.alpha = 0;
            } completion:nil];
        }
                         completion:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 250.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    
    NSURL *urlLogo = AirlineLogo(ticket.airline);
    NSData *data = [NSData dataWithContentsOfURL:urlLogo];
    UIImage *imageLogo = [[UIImage alloc] initWithData:data];
    _airlineLogoView.image = imageLogo;
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    
    NSURL *urlLogo = AirlineLogo(favoriteTicket.airline);
    NSData *data = [NSData dataWithContentsOfURL:urlLogo];
    UIImage *imageLogo = [[UIImage alloc] initWithData:data];
    _airlineLogoView.image = imageLogo;
}

- (void)setMapPrice:(MapPrice *)mapPrice {
    _mapPrice = mapPrice;

    _priceLabel.text = [NSString stringWithFormat:@"%ld руб.", (long)mapPrice.value];
    _placesLabel.text = [NSString stringWithFormat:@"%@ (%@)", mapPrice.destination.name, mapPrice.destination.code];
}

- (void)setFavoriteMapPrice:(FavoriteMapPrice *)favoriteMapPrice {
    _favoriteMapPrice = favoriteMapPrice;
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteMapPrice.value];
    _placesLabel.text = [NSString stringWithFormat:@"%@", favoriteMapPrice.departure];
}

@end
