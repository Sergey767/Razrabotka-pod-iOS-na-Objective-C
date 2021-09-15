//
//  TicketTableViewCell.h
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "MapPrice.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

    @property (nonatomic, strong) Ticket *ticket;
    @property (nonatomic, strong) FavoriteTicket *favoriteTicket;
    @property (nonatomic, strong) MapPrice *mapPrice;
    @property (nonatomic, strong) FavoriteMapPrice *favoriteMapPrice;
    @property (nonatomic, strong) UIImageView *airlineNotificationLogoView;

@end

NS_ASSUME_NONNULL_END
