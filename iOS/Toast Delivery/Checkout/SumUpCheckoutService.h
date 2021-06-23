//
//  SumUpCheckoutService.h
//  Toast Delivery
//

#import "CheckoutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SumUpCheckoutService : NSObject <CheckoutAPI>

- (instancetype)initWithMerchantCode:(NSString *)merchantCode accessToken:(NSString *)accessToken NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
