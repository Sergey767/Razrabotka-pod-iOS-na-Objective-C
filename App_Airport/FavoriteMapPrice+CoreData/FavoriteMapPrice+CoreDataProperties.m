//
//  FavoriteMapPrice+CoreDataProperties.m
//  App_Airport
//
//  Created by Сергей Горячев on 24.07.2021.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

//@dynamic destination;
//@dynamic origin;
@dynamic departure;
@dynamic returnDate;
@dynamic numberOfChanges;
@dynamic value;
@dynamic distance;
@dynamic actual;
@dynamic created;

@end
