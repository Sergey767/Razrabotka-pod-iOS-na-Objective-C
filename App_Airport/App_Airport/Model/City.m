//
//  City.m
//  App_Airport
//
//  Created by Сергей Горячев on 22.06.2021.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
        _timeZone = [dictionary valueForKey:@"time_zone"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
        [self localizeName];
    }
    return self;
}

- (void)localizeName {
    if (!_translations) return;
    NSLocale *locale = [NSLocale currentLocale];
    NSString *localeId = [locale.localeIdentifier substringToIndex:2];
    if (localeId) {
        if ([_translations valueForKey:localeId]) {
            self.name = [_translations valueForKey:localeId];
        }
    }
}

@end
