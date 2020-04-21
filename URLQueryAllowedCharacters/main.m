//
//  main.m
//  URLQueryAllowedCharacters
//
//  Created by Timothy Wood on 4/21/20.
//  Copyright © 2020 The Omni Group. All rights reserved.
//

#import <Foundation/Foundation.h>

static void ShowCharacterSets(void)
{
    // NOTE: This is the character set allowed in the *entire* query. Individual query terms can't contain '=' or '&'.
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];

    // Print the printable ASCII subset of allowed/disallowed characters
    NSMutableString *allPrintable = [NSMutableString string];
    NSMutableString *allowedCharacters = [NSMutableString string];
    NSMutableString *disallowedCharacters = [NSMutableString string];

    for (unichar c = 0; c <= 255; c++) {
        if (!isascii(c) || !isprint(c)) {
            continue;
        }

        [allPrintable appendFormat:@"%c", c];

        if ([allowedCharacterSet characterIsMember:(unichar)c]) {
            [allowedCharacters appendFormat:@"%c", c];
        } else {
            [disallowedCharacters appendFormat:@"%c", c];
        }
    }

    NSLog(@"All Printable: %@", allPrintable);
    NSLog(@"Allowed: %@", allowedCharacters);
    NSLog(@"Disallowed: %@", disallowedCharacters);
}

// Build a sample x-callback URL
static void ShowExampleURL(void)
{
    NSString *callbackURLString;
    {
        NSURLComponents *components = [[NSURLComponents alloc] init];
        components.scheme = @"reply-app";
        components.host = @"localhost";
        components.path = @"/reply-path";
        components.queryItems = @[
            [[NSURLQueryItem alloc] initWithName:@"key" value:@"value"]
        ];

        callbackURLString = [[components URL] absoluteString];
    }

    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"target-app";
    components.host = @"localhost";
    components.path = @"/query-path";

    components.queryItems = @[
        [[NSURLQueryItem alloc] initWithName:@"search" value:@"123"],
        [[NSURLQueryItem alloc] initWithName:@"x-success" value:callbackURLString],
    ];

    NSLog(@"Example URL: %@", [components.URL absoluteString]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ShowCharacterSets();
        ShowExampleURL();
    }
    return 0;
}
