/**
 * iAdAttributes
 *
 * Created by Your Name
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "ComGaurangIadattributesModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <iAd/iAd.h>

@implementation ComGaurangIadattributesModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"61c42b8a-7888-4af2-aa4a-e0f180c84fc1";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.gaurang.iadattributes";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[DEBUG] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

- (void)getAnaliticsDataWithBlockNew {
    
    if (![[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [self fireEvent:@"analyticsInfo" withObject:@{@"error" : @"iAds API not supported" }];
        return;
    }
    
    [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *details, NSError *error) {
        if (error) {
            NSLog(@"requestAttributionDetailsWithBlock returned error: %@", error);
            [self fireEvent:@"analyticsInfo" withObject:@{@"error" : error.localizedDescription }];
            return;
        }

        NSMutableDictionary *mergedContext = [NSMutableDictionary dictionaryWithCapacity:details.count];

        [mergedContext addEntriesFromDictionary:details];
        NSLog(@"=== >> %@", mergedContext);

        NSError *errorJson;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mergedContext
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&errorJson];
        NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (errorJson != nil){
            [self fireEvent:@"analyticsInfo" withObject:@{@"error" : errorJson.localizedDescription }];
        }
        else if (errorJson == nil && string != nil) {
            [self fireEvent:@"analyticsInfo" withObject:@{ @"message" : string}];
        }else {
            [self fireEvent:@"analyticsInfo" withObject:@{ @"error" : @"Invalid Access" }];
        }
    }];
    
    
}

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)getAttribution:(id)args
{
    [self getAnaliticsDataWithBlockNew];
    return @"Calling Attribution API...";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
