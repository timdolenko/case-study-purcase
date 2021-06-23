//
//  SumUpCheckoutService.m
//  Toast Delivery
//

#import "SumUpCheckoutService.h"

static inline id safeCast(id obj, Class class) {
    return [obj isKindOfClass:class] ? obj : nil;
}

static inline NSError *createDecodingError() {
    return [NSError errorWithDomain:@"com.sumup.challenge.toastdelivery.SumUpCheckoutService" code:0 userInfo:nil];
}

static inline void logInvalidData(NSData *data) {
    NSLog(@"Received invalid data: %@", data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"null");
}

@interface SumUpCheckoutService ()
@property (nonatomic, readonly) NSString *merchantCode;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSURLSession *session;
@end

@implementation SumUpCheckoutService

- (instancetype)initWithMerchantCode:(NSString *)merchantCode accessToken:(NSString *)accessToken {
    NSParameterAssert(merchantCode);
    NSParameterAssert(accessToken);

    self = [super init];
    if (self) {
        _merchantCode = [merchantCode copy];
        _accessToken = [accessToken copy];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)createCheckoutWithRequest:(CheckoutRequest *)request completion:(void (^)(CheckoutResponse * _Nullable, NSError * _Nullable))completion {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.sumup.com/v0.1/checkouts"]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *body = @{
        @"checkout_reference": request.reference,
        @"amount": request.amount,
        @"currency": request.currencyCode,
        @"merchant_code": self.merchantCode
    };
    urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:kNilOptions error:nil];

    [[self.session dataTaskWithRequest:[urlRequest copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }

        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError) {
            logInvalidData(data);
            completion(nil, jsonError);
            return;
        }
        NSDictionary *jsonDict = safeCast(json, [NSDictionary class]);
        NSString *reference = safeCast(jsonDict[@"checkout_reference"], [NSString class]);
        NSNumber *amount = safeCast(jsonDict[@"amount"], [NSNumber class]);
        NSString *currencyCode = safeCast(jsonDict[@"currency"], [NSString class]);
        NSString *identifier = safeCast(jsonDict[@"id"], [NSString class]);
        NSString *status = safeCast(jsonDict[@"status"], [NSString class]);
        NSString *dateString = safeCast(jsonDict[@"date"], [NSString class]);
        if (!reference || !amount || !currencyCode || !identifier || !status || !dateString) {
            logInvalidData(data);
            completion(nil, createDecodingError());
            return;
        }

        NSISO8601DateFormatter *formatter = [NSISO8601DateFormatter new];
        formatter.formatOptions = (NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithFractionalSeconds);
        NSDate *date = [formatter dateFromString:dateString];
        if (!date) {
            logInvalidData(data);
            completion(nil, createDecodingError());
            return;
        }

        CheckoutResponse *parsedResponse = [[CheckoutResponse alloc] initWithReference:reference
                                                                          amount:[NSDecimalNumber decimalNumberWithString:amount.stringValue]
                                                                    currencyCode:currencyCode
                                                                      identifier:identifier
                                                                          status:status
                                                                            date:date];
        completion(parsedResponse, nil);
    }] resume];
}

@end
