/* Copyright Airship and Contributors */

#import "UAOverlayInboxMessageActionPredicate+Internal.h"

@implementation UAOverlayInboxMessageActionPredicate

-(BOOL)applyActionArguments:(UAActionArguments *)args {
    return (BOOL)(args.situation != UASituationForegroundPush);
}

@end
