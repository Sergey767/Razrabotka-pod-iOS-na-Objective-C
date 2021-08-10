//
//  CoreDataHelper.m
//  App_Airport
//
//  Created by Сергей Горячев on 21.07.2021.
//

#import "CoreDataHelper.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPrice+CoreDataClass.h"

#define urlForResource @"DataModel"
#define extension @"momd"
#define baseSqlite @"base.sqlite"
#define entityNameTicket @"FavoriteTicket"
#define entityNameMapPrice @"FavoriteMapPrice"
#define createdFavorite @"created"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance {
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:urlForResource withExtension:extension];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:baseSqlite];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityNameTicket];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (FavoriteMapPrice *)favoriteFromMapPrice:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.predicate = [NSPredicate predicateWithFormat:@"departure == %@ AND numberOfChanges == %ld AND value == %ld AND distance == %ld", mapPrice.departure, mapPrice.numberOfChanges, mapPrice.value, mapPrice.distance];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice {
    return [self favoriteFromMapPrice:mapPrice] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:entityNameTicket inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    
    [self save];
}

- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [NSEntityDescription insertNewObjectForEntityForName:entityNameMapPrice inManagedObjectContext:_managedObjectContext];
    favoriteMapPrice.departure = mapPrice.departure;
    favoriteMapPrice.returnDate = mapPrice.returnDate;
    favoriteMapPrice.numberOfChanges = mapPrice.numberOfChanges;
    favoriteMapPrice.value = mapPrice.value;
    favoriteMapPrice.distance = mapPrice.distance;
    favoriteMapPrice.actual = mapPrice.actual;
    favoriteMapPrice.created = [NSDate date];
    
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [self favoriteFromMapPrice:mapPrice];
    if (favoriteMapPrice) {
        [_managedObjectContext deleteObject:favoriteMapPrice];
        [self save];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityNameTicket];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:createdFavorite ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (NSArray *)favoritesMapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityNameMapPrice];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:createdFavorite ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
