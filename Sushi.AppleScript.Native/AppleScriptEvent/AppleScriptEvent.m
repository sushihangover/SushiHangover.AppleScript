//
//  AppleScriptEvent.m
//  AppleScriptEvent
//
//  Created by Sushi on 12/2/15.
//  Copyright © 2015 Sushi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppleScriptEvent.h"

//@implementation AppleScriptEvent

BOOL ExecuteScriptFromString (NSString* scriptString, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug)
{
    if (debug) {
        NSLog(@"AppleScript: ExecuteScript() function enter");
    }
    
    BOOL executionSucceed = NO;
    
    if (debug) {
        NSLog(@"AppleScript, script: %@", scriptString);
        NSLog(@"AppleScript, functionName: %@", functionName);
        NSLog(@"AppleScript, arguments: %@", argumentArray);
    }
    
    BOOL                    compileOK;
    NSAppleScript           * appleScript;
    NSAppleEventDescriptor  * thisApplication, *containerEvent;
//    NSURL                   * pathURL = [NSURL fileURLWithPath:scriptString];
    
    NSDictionary * appleScriptCreationError = nil;
    appleScript = [[NSAppleScript alloc] initWithSource:scriptString ]; // error:&appleScriptCreationError];
    if (appleScript == nil)
    {
        if (debug) {
            NSLog(@"AppleScript: Could not instantiate applescript %@", scriptString);
        }
        strncpy(scriptReturn, [appleScriptCreationError[@"NSAppleScriptErrorBriefMessage"] UTF8String], 254);
        [appleScript release];
        return executionSucceed;
    } else {
        compileOK = [appleScript compileAndReturnError:&appleScriptCreationError];
        if (appleScriptCreationError){
            if (debug) {
                NSLog(@"AppleScript: Could not instantiate applescript %@", appleScriptCreationError);
            }
            strncpy(scriptReturn, [appleScriptCreationError[@"NSAppleScriptErrorBriefMessage"] UTF8String], 254);
            [appleScript release];
            return executionSucceed;
        }
    }

    if (functionName && [functionName length])
    {
        int pid = [[NSProcessInfo processInfo] processIdentifier];
        thisApplication = [NSAppleEventDescriptor descriptorWithDescriptorType:typeKernelProcessID
                                                                         bytes:&pid
                                                                        length:sizeof(pid)];
#define kASAppleScriptSuite 'ascr'
#define kASSubroutineEvent  'psbr'
#define keyASSubroutineName 'snam'
        
        containerEvent = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                  eventID:kASSubroutineEvent
                                                         targetDescriptor:thisApplication
                                                                 returnID:kAutoGenerateReturnID
                                                            transactionID:kAnyTransactionID];
        //Set the target function
        @try {
            [containerEvent setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:functionName]
                                    forKeyword:keyASSubroutineName];
        }
        @catch (NSException *exception) {
            NSLog(@"AppleScript: NSException %@", exception.reason);
            strncpy(scriptReturn, exception.reason, 254);
            return executionSucceed;
        }
        @finally {
        }
        
        //Pass arguments - arguments is expecting an NSArray with only NSString objects
        if ([argumentArray count])
        {
            NSAppleEventDescriptor  *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
            NSString                *object;
            
            for (object in argumentArray) {
                [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:object]
                                    atIndex:([arguments numberOfItems] + 1)]; //This +1 seems wrong... but it's not
            }
            
            [containerEvent setParamDescriptor:arguments forKeyword:keyDirectObject];
            [arguments release];
        }
        
        //Execute the event
        NSDictionary * executionError = nil;
        NSAppleEventDescriptor * result;
        @try {
            result = [appleScript executeAppleEvent:containerEvent error:&executionError];
        }
        @catch (NSException *exception) {
            NSLog(@"AppleScript: NSException %@", exception.reason);
            strncpy(scriptReturn, exception.reason, 254);
            return executionSucceed;
        }
        if (executionError != nil)
        {
            if (debug) {
                NSLog(@"AppleScript: Error while executing script. Error %@", executionError);
            }
            NSNumber *number = executionError[@"NSAppleScriptErrorNumber"];
            NSString *string = [number stringValue];
            strncpy(scriptReturn, [string UTF8String], 254);
        }
        else
        {
            if (debug) {
                NSLog(@"AppleScript: Script execution succeed. Result(%@)",result);
            }
            strncpy(scriptReturn, [result.stringValue UTF8String], 254);
            executionSucceed = YES;
        }
    }
    else
    {
        NSDictionary * executionError = nil;
        NSAppleEventDescriptor * result = [appleScript executeAndReturnError:&executionError];
        
        if (executionError != nil)
        {
            if (debug) {
                NSLog(@"AppleScript: Error while executing script. Error %@", executionError);
            }
            strncpy(scriptReturn, ([executionError[@"NSAppleScriptErrorBriefMessage"] UTF8String]), 254);
        }
        else
        {
            if (debug) {
                NSLog(@"AppleScript: Script execution has succeed. Result(%@)",result);
            }
            strncpy(scriptReturn, [result.stringValue UTF8String], 254);
            executionSucceed = YES;
        }
    }
    if (debug) {
        NSLog(@"AppleScript: ExecuteScript() function exit");
    }
    [appleScript release];
    return executionSucceed;
}


BOOL ExecuteScriptFromFile (NSString* path, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug)
{
    if (debug) {
        NSLog(@"AppleScript: ExecuteScript() function enter");
    }
    
    BOOL executionSucceed = NO;
    
    if (debug) {
        NSLog(@"AppleScript, path: %@", path);
        NSLog(@"AppleScript, functionName: %@", functionName);
        NSLog(@"AppleScript, arguments: %@", argumentArray);
    }
    
    NSAppleScript           * appleScript;
    NSAppleEventDescriptor  * thisApplication, *containerEvent;
    NSURL                   * pathURL = [NSURL fileURLWithPath:path];
    
    NSDictionary * appleScriptCreationError = nil;
    appleScript = [[NSAppleScript alloc] initWithContentsOfURL:pathURL error:&appleScriptCreationError];
    
    if (appleScriptCreationError)
    {
        if (debug) {
            NSLog(@"AppleScript: Could not instantiate applescript %@", appleScriptCreationError);
        }
        strncpy(scriptReturn, [appleScriptCreationError[@"NSAppleScriptErrorBriefMessage"] UTF8String], 254);
    }
    else
    {
        if (functionName && [functionName length])
        {
            int pid = [[NSProcessInfo processInfo] processIdentifier];
            thisApplication = [NSAppleEventDescriptor descriptorWithDescriptorType:typeKernelProcessID
                                                                             bytes:&pid
                                                                            length:sizeof(pid)];
#define kASAppleScriptSuite 'ascr'
#define kASSubroutineEvent  'psbr'
#define keyASSubroutineName 'snam'
            
            containerEvent = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                      eventID:kASSubroutineEvent
                                                             targetDescriptor:thisApplication
                                                                     returnID:kAutoGenerateReturnID
                                                                transactionID:kAnyTransactionID];
            //Set the target function
            @try {
                [containerEvent setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:functionName]
                                        forKeyword:keyASSubroutineName];
            }
            @catch (NSException *exception) {
                NSLog(@"AppleScript: NSException %@", exception.reason);
                strncpy(scriptReturn, exception.reason, 254);
                return executionSucceed;
            }
            @finally {
            }
            
            //Pass arguments - arguments is expecting an NSArray with only NSString objects
            if ([argumentArray count])
            {
                NSAppleEventDescriptor  *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
                NSString                *object;
                
                for (object in argumentArray) {
                    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:object]
                                        atIndex:([arguments numberOfItems] + 1)]; //This +1 seems wrong... but it's not
                }
                
                [containerEvent setParamDescriptor:arguments forKeyword:keyDirectObject];
                [arguments release];
            }
            
            //Execute the event
            NSDictionary * executionError = nil;
            NSAppleEventDescriptor * result;
            @try {
                result = [appleScript executeAppleEvent:containerEvent error:&executionError];
            }
            @catch (NSException *exception) {
                NSLog(@"AppleScript: NSException %@", exception.reason);
                strncpy(scriptReturn, exception.reason, 254);
                return executionSucceed;
            }
            if (executionError != nil)
            {
                if (debug) {
                    NSLog(@"AppleScript: Error while executing script. Error %@", executionError);
                }
                NSNumber *number = executionError[@"NSAppleScriptErrorNumber"];
                NSString *string = [number stringValue];
                strncpy(scriptReturn, [string UTF8String], 254);
            }
            else
            {
                if (debug) {
                    NSLog(@"AppleScript: Script execution succeed. Result(%@)",result);
                }
                strncpy(scriptReturn, [result.stringValue UTF8String], 254);
                executionSucceed = YES;
            }
        }
        else
        {
            NSDictionary * executionError = nil;
            NSAppleEventDescriptor * result = [appleScript executeAndReturnError:&executionError];
            
            if (executionError != nil)
            {
                if (debug) {
                    NSLog(@"AppleScript: Error while executing script. Error %@", executionError);
                }
                strncpy(scriptReturn, ([executionError[@"NSAppleScriptErrorBriefMessage"] UTF8String]), 254);
            }
            else
            {
                if (debug) {
                    NSLog(@"AppleScript: Script execution has succeed. Result(%@)",result);
                }
                strncpy(scriptReturn, [result.stringValue UTF8String], 254);
                executionSucceed = YES;
            }
        }
    }
    if (debug) {
        NSLog(@"AppleScript: ExecuteScript() function exit");
    }
    [appleScript release];
    return executionSucceed;
}


//@end
