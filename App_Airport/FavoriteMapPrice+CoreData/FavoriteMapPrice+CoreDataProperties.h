//
//  FavoriteMapPrice+CoreDataProperties.h
//  App_Airport
//
//  Created by Сергей Горячев on 24.07.2021.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"
#import "City.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

//@property (nullable, nonatomic, copy) City *destination;
//@property (nullable, nonatomic, copy) City *origin;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int16_t numberOfChanges;
@property (nonatomic) int64_t value;
@property (nonatomic) int64_t distance;
@property (nonatomic) BOOL actual;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
