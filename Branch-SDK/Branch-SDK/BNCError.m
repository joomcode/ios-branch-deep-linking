//
//  BNCError.m
//  Branch-SDK
//
//  Created by Qinwei Gong on 11/17/14.
//  Copyright (c) 2014 Branch Metrics. All rights reserved.
//


#import "BNCError.h"


NSErrorDomain _Nonnull const BNCErrorDomain = @"io.branch.error";


@implementation BNCError

- (instancetype _Nullable) initWithCode:(BNCErrorCode)code
                                 reason:(id _Nullable)reasonFormat
                              arguments:(va_list)args {

    NSString * reasonString = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = [BNCError localizedDescriptionForCode:code];

    if ([reasonFormat isKindOfClass:[NSError class]]) {

        userInfo[NSUnderlyingErrorKey] = reasonFormat;
        reasonString = [(NSError*)reasonFormat localizedDescription];

    } else if ([reasonFormat isKindOfClass:[NSString class]]) {

        reasonString = (args)
            ? [[NSString alloc] initWithFormat:reasonFormat arguments:args]
            : reasonFormat;

    } else if (reasonFormat) {

        reasonString = [reasonFormat description];

    }

    if (reasonString) {
        userInfo[NSLocalizedFailureReasonErrorKey] = reasonString;
    }

    self = [super initWithDomain:BNCErrorDomain code:code userInfo:userInfo];
    return self;
}

+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code {
    return [[BNCError alloc] initWithCode:code reason:nil arguments:NULL];
}

+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code reason:(id _Nullable)reason {
    return [[BNCError alloc] initWithCode:code reason:reason arguments:NULL];
}

+ (instancetype _Nullable) errorWithCode:(BNCErrorCode)code
                            reasonFormat:(NSString*_Nonnull)reasonFormat, ... NS_FORMAT_FUNCTION(2,3) {

    va_list args;
    va_start(args, reasonFormat);
    BNCError *error = [[BNCError alloc] initWithCode:code reason:reasonFormat arguments:args];
    va_end(args);

    return error;
}

+ (NSString* _Nonnull) localizedDescriptionForCode:(BNCErrorCode)code {

    NSString *bestLanguageName = [self bestLanguageForLanguages:[NSLocale preferredLanguages]];
    NSArray *errorDescriptions = [self errorDescriptionDictionary][bestLanguageName];

    NSInteger errorIndex = code - BNCInitError;
    if (errorIndex < 0 || errorIndex >= errorDescriptions.count) {
        errorIndex = 0;
    }

    return errorDescriptions[errorIndex];
}

+ (NSString* _Nonnull) bestLanguageForLanguages:(NSArray<NSString*>*)languages {

    NSDictionary *descriptions = [self errorDescriptionDictionary];
    for (NSString *language in languages) {
        if (descriptions[language]) {
            return language;
        }
        NSRange range = [language rangeOfString:@"_"];
        if (range.location != NSNotFound) {
            NSString *shortName = [language substringToIndex:range.location];
            if (descriptions[shortName]) {
                return shortName;
            }
        }
    }
    return @"en";
}

+ (instancetype) errorWithDomain:(nonnull NSErrorDomain)domain
                            code:(NSInteger)code
                        userInfo:(nullable NSDictionary *)dictionary {
    NSLog(@"Use [BNCError errorWithCode instead.");
    return [super errorWithDomain:domain code:code userInfo:dictionary];
}

+ (NSDictionary<NSString*, NSArray<NSString*>*>*) errorDescriptionDictionary {
    @synchronized (self) {
    
        // Can't load the string from a resource if we're built as a static library.
        static NSDictionary<NSString*, NSArray<NSString*>*> *descriptions = nil;

        if (!descriptions) {
            descriptions = @{

                // English
                @"en": @[
                    @"BNCInitError",
                    @"BNCDuplicateResourceError",
                    @"BNCRedeemCreditsError",
                    @"BNCBadRequestError",
                    @"BNCServerProblemError",
                    @"BNCNilLogError",
                    @"BNCVersionError",
                    @"BNCInternalError"
                ],

                // Spanish
                @"es": @[
                    @"BNCInitError",
                    @"BNCDuplicateResourceError",
                    @"BNCRedeemCreditsError",
                    @"BNCBadRequestError",
                    @"BNCServerProblemError",
                    @"BNCNilLogError",
                    @"BNCVersionError",
                    @"BNCInternalError"
                ],
            };

            // Sanity check:
            NSInteger errorCount = BNCInternalError - BNCInitError + 1;
            for (NSString *language in descriptions.keyEnumerator) {
                NSArray* array = descriptions[language];
                if (array.count != errorCount) {
                    NSLog(@"Internal error. Language %@ only has %ld strings.  Expecting %ld.",
                          language, (long)array.count, (long)errorCount);
                }
            }
        }
        return descriptions;
    }
}

@end
