//
//  CheckoutAPI.h
//  Toast Delivery
//

@import Foundation;

@class CheckoutRequest;
@class CheckoutResponse;

NS_ASSUME_NONNULL_BEGIN

@protocol CheckoutAPI<NSObject>

- (void)createCheckoutWithRequest:(CheckoutRequest *)request completion:(void(^)(CheckoutResponse *_Nullable response, NSError *_Nullable error))completion;

@end

@interface CheckoutRequest : NSObject

@property (nonatomic, copy, readonly) NSString *reference;
@property (nonatomic, copy, readonly) NSDecimalNumber *amount;
/// The currency code must match the currency of your account's country.
@property (nonatomic, copy, readonly) NSString *currencyCode;

- (instancetype)initWithReference:(NSString *)reference
                           amount:(NSDecimalNumber *)amount
                     currencyCode:(NSString *)currencyCode NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface CheckoutResponse : NSObject

@property (nonatomic, copy, readonly) NSString *reference;
@property (nonatomic, copy, readonly) NSDecimalNumber *amount;
@property (nonatomic, copy, readonly) NSString *currencyCode;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSDate *date;

- (instancetype)initWithReference:(NSString *)reference
                           amount:(NSDecimalNumber *)amount
                     currencyCode:(NSString *)currencyCode
                       identifier:(NSString *)identifier
                           status:(NSString *)status
                             date:(NSDate *)date NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
