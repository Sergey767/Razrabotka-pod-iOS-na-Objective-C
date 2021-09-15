//
//  CoreDataHelper.h
//  App_Airport
//
//  Created by Сергей Горячев on 21.07.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Ticket.h"
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

- (BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice;
- (NSArray *)favoritesMapPrice;
- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice;
- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice;

@end

NS_ASSUME_NONNULL_END
