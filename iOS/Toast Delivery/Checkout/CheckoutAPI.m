//
//  CheckoutAPI.m
//  Toast Delivery
//

#import "CheckoutAPI.h"

@implementation CheckoutRequest

- (instancetype)initWithReference:(NSString *)reference amount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode {
    self = [super init];
    if (self) {
        _reference = [reference copy];
        _amount = [amount copy];
        _currencyCode = [currencyCode copy];
    }
    return self;
}

@end

@implementation CheckoutResponse

- (instancetype)initWithReference:(NSString *)reference amount:(NSDecimalNumber *)amount currencyCode:(NSString *)currencyCode identifier:(NSString *)identifier status:(NSString *)status date:(NSDate *)date {
    self = [super init];
    if (self) {
        _reference = [reference copy];
        _amount = [amount copy];
        _currencyCode = [currencyCode copy];
        _identifier = [identifier copy];
        _status = [status copy];
        _date = [date copy];
    }
    return self;
}

@end
