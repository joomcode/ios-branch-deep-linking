//
//  BNCError.Test.m
//  Branch-TestBed
//
//  Created by edward on 3/3/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "BNCError.h"
#import "OCMock.h"


@interface BNCErrorTest : XCTestCase
@end


@implementation BNCErrorTest

- (void)testDefault {

    NSError *error =
        [NSError errorWithDomain:NSURLErrorDomain
            code:NSURLErrorNotConnectedToInternet
            userInfo:@{
                NSLocalizedDescriptionKey: @"Not connected to the internet",
                NSLocalizedFailureReasonErrorKey: @"The internet is not available now"
            }];

    BNCError *testError = nil;
    testError = [BNCError errorWithCode:BNCBadRequestError reasonFormat:@"Bad Request with error: %@", error];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"] &&
        [testError.localizedFailureReason isEqualToString:
            @"Bad Request with error: Error Domain=NSURLErrorDomain Code=-1009 "
             "\"Not connected to the internet\" UserInfo={NSLocalizedDescription="
             "Not connected to the internet, NSLocalizedFailureReason="
             "The internet is not available now}"]
    );

    testError = [BNCError errorWithCode:BNCBadRequestError reason:error];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"] &&
        [testError.localizedFailureReason isEqualToString:@"Not connected to the internet"]
    );

    NSDictionary *dictionary = @{ @"key": @"value" };
    testError = [BNCError errorWithCode:BNCBadRequestError reason:dictionary];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"] &&
        [testError.localizedFailureReason isEqualToString:@"{\n    key = value;\n}"]
    );

    testError = [BNCError errorWithCode:BNCBadRequestError];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"] &&
        testError.localizedFailureReason == nil
    );
}

- (void) testBritishEnglish {

    id localeMock = OCMClassMock([NSLocale class]);
    [[[localeMock expect]
        andReturn:@[ @"en_GB" ]]
            preferredLanguages];

    BNCError *testError = [BNCError errorWithCode:BNCBadRequestError];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"]
    );

    [localeMock verify];
    [localeMock stopMocking];
}

- (void) testUnknownLanguage {

    id localeMock = OCMClassMock([NSLocale class]);
    [[[localeMock expect]
        andReturn:@[ @"zz_XX" ]]
            preferredLanguages];

    BNCError *testError = [BNCError errorWithCode:BNCBadRequestError];
    XCTAssert(
        [testError.domain isEqualToString:BNCErrorDomain] &&
        testError.code == BNCBadRequestError &&
        [testError.localizedDescription isEqualToString:@"BNCBadRequestError"]
    );

    [localeMock verify];
    [localeMock stopMocking];
}

- (void) testAssorted {

    BNCError *testError = [BNCError errorWithCode:BNCBadRequestError];
    XCTAssert([testError isKindOfClass:[NSError class]]);
    XCTAssert([testError isKindOfClass:[BNCError class]]);
}

@end
