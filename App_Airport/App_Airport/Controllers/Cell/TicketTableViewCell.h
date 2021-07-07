//
//  TicketTableViewCell.h
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

    @property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
