#import <MtProtoKit/MTSubscriber.h>

#import <libkern/OSAtomic.h>

@interface MTSubscriberBlocks : NSObject {
@public
    void (^_next)(id);
    void (^_error)(id);
    void (^_completed)();
}

@end

@implementation MTSubscriberBlocks

- (instancetype)initWithNext:(void (^)(id))next error:(void (^)(id))error completed:(void (^)())completed {
    self = [super init];
    if (self != nil) {
        _next = [next copy];
        _error = [error copy];
        _completed = [completed copy];
    }
    return self;
}

@end

@interface MTSubscriber ()
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@protected
    OSSpinLock _lock;
    bool _terminated;
    id<MTDisposable> _disposable;
    MTSubscriberBlocks *_blocks;
}
#pragma clang diagnostic pop


@end

@implementation MTSubscriber

- (instancetype)initWithNext:(void (^)(id))next error:(void (^)(id))error completed:(void (^)())completed
{
    self = [super init];
    if (self != nil)
    {
        _blocks = [[MTSubscriberBlocks alloc] initWithNext:next error:error completed:completed];
    }
    return self;
}

- (void)_assignDisposable:(id<MTDisposable>)disposable
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    bool dispose = false;
    OSSpinLockLock(&_lock);
    if (_terminated) {
        dispose = true;
    } else {
        _disposable = disposable;
    }
    OSSpinLockUnlock(&_lock);
#pragma clang diagnostic pop

    if (dispose) {
        [disposable dispose];
    }
}

- (void)_markTerminatedWithoutDisposal
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    MTSubscriberBlocks *blocks = nil;
    if (!_terminated)
    {
        blocks = _blocks;
        _blocks = nil;
        
        _terminated = true;
    }
    OSSpinLockUnlock(&_lock);
#pragma clang diagnostic pop

    if (blocks) {
        blocks = nil;
    }
}

- (void)putNext:(id)next
{
    MTSubscriberBlocks *blocks = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    if (!_terminated) {
        blocks = _blocks;
    }
    OSSpinLockUnlock(&_lock);
    
    if (blocks && blocks->_next) {
        blocks->_next(next);
    }
#pragma clang diagnostic pop

}

- (void)putError:(id)error
{
    bool shouldDispose = false;
    MTSubscriberBlocks *blocks = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    if (!_terminated)
    {
        blocks = _blocks;
        _blocks = nil;
        
        shouldDispose = true;
        _terminated = true;
    }
    OSSpinLockUnlock(&_lock);
    
    if (blocks && blocks->_error) {
        blocks->_error(error);
    }
    
    if (shouldDispose)
        [self->_disposable dispose];
#pragma clang diagnostic pop

}

- (void)putCompletion
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    bool shouldDispose = false;
    MTSubscriberBlocks *blocks = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    if (!_terminated)
    {
        blocks = _blocks;
        _blocks = nil;
        
        shouldDispose = true;
        _terminated = true;
    }
    OSSpinLockUnlock(&_lock);
#pragma clang diagnostic pop

    if (blocks && blocks->_completed)
        blocks->_completed();
    
    if (shouldDispose)
        [self->_disposable dispose];
#pragma clang diagnostic pop

}

- (void)dispose
{
    [self->_disposable dispose];
}

@end
