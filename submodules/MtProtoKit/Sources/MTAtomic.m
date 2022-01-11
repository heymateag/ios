#import <MtProtoKit/MTAtomic.h>

#import <libkern/OSAtomic.h>

@interface MTAtomic ()
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    volatile OSSpinLock _lock;
    #pragma clang diagnostic pop
    id _value;
}

@end

@implementation MTAtomic

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self != nil)
    {
        _value = value;
    }
    return self;
}

- (id)swap:(id)newValue
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id previousValue = nil;
    OSSpinLockLock(&_lock);
    previousValue = _value;
    _value = newValue;
    OSSpinLockUnlock(&_lock);
    #pragma clang diagnostic pop
    return previousValue;
}

- (id)value
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id previousValue = nil;
    OSSpinLockLock(&_lock);
    previousValue = _value;
    OSSpinLockUnlock(&_lock);
    #pragma clang diagnostic pop
    
    return previousValue;
}

- (id)modify:(id (^)(id))f
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id newValue = nil;
    OSSpinLockLock(&_lock);
    newValue = f(_value);
    _value = newValue;
    OSSpinLockUnlock(&_lock);
#pragma clang diagnostic pop
    return newValue;
}

- (id)with:(id (^)(id))f
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id result = nil;
    OSSpinLockLock(&_lock);
    result = f(_value);
    OSSpinLockUnlock(&_lock);
#pragma clang diagnostic pop
    return result;
}

@end
