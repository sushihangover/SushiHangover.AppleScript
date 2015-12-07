//
//  AppleScriptEvent.h
//  AppleScriptEvent
//
//  Created by SushiHangover\RobertN on 12/2/15.
//  Copyright © 2015 Sushi. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT BOOL ExecuteScriptFromString (NSString* scriptString, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug);

FOUNDATION_EXPORT BOOL ExecuteScriptFromFile (NSString* path, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug);

//@interface AppleScriptEvent : NSObject


//@end
