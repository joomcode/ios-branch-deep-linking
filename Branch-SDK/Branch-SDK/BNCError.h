//
//  BNCError.h
//  Branch-SDK
//
//  Created by Qinwei Gong on 11/17/14.
//  Copyright (c) 2014 Branch Metrics. All rights reserved.
//


#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSErrorDomain _Nonnull const BNCErrorDomain;

typedef NS_ENUM(NSUInteger, BNCErrorCode) {
    BNCInitError                = 1000,
    BNCDuplicateResourceError   = 1001,
    BNCRedeemCreditsError       = 1002,
    BNCBadRequestError          = 1003,
    BNCServerProblemError       = 1004,
    BNCNilLogError              = 1005,
    BNCVersionError             = 1006,
    BNCInternalError            = 1007,
};

#pragma mark - BNCError

@interface BNCError : NSError
- (instancetype _Nullable) initWithCode:(BNCErrorCode)code
                                  reason:(id _Nullable)reasonFormat
                               arguments:(va_list)args;

+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code;
+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code reason:(id _Nullable)reason;
+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code reasonFormat:(NSString*_Nonnull)reasonFormat, ... NS_FORMAT_FUNCTION(2,3);
@end
