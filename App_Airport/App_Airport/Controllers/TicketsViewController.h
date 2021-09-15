//
//  TicketsViewController.h
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import <UIKit/UIKit.h>

typedef enum TicketType {
    TicketTypeMapPrice,
    TicketTypeFound
} TicketType;

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController
- (instancetype)initWithType:(TicketType)type;
- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initWithMapPrices:(NSArray *)prices;
- (instancetype)initFavoriteTicketsController;
@end

NS_ASSUME_NONNULL_END
