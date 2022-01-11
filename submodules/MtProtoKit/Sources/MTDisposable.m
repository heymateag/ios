#import <MtProtoKit/MTDisposable.h>

#import <libkern/OSAtomic.h>
#import <objc/runtime.h>

@interface MTBlockDisposable ()
{
    void *_block;
}

@end

@implementation MTBlockDisposable

#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (instancetype)initWithBlock:(void (^)())block
{
    self = [super init];
    if (self != nil)
    {
        _block = (__bridge_retained void *)[block copy];
    }
    return self;
}

- (void)dealloc
{
    void *block = _block;
    if (block != NULL)
    {
        if (OSAtomicCompareAndSwapPtr(block, 0, &_block))
        {
            if (block != nil)
            {
                __strong id strongBlock = (__bridge_transfer id)block;
                strongBlock = nil;
            }
        }
    }
}

- (void)dispose
{
    void *block = _block;
    if (block != NULL)
    {
        if (OSAtomicCompareAndSwapPtr(block, 0, &_block))
        {
            if (block != nil)
            {
                __strong id strongBlock = (__bridge_transfer id)block;
                ((dispatch_block_t)strongBlock)();
                strongBlock = nil;
            }
        }
    }
}
#pragma mark clang diagnostic pop

@end

@interface MTMetaDisposable ()
{
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLock _lock;
#pragma mark clang diagnostic pop

    bool _disposed;
    id<MTDisposable> _disposable;
}

@end

@implementation MTMetaDisposable

- (void)setDisposable:(id<MTDisposable>)disposable
{
    id<MTDisposable> previousDisposable = nil;
    bool dispose = false;
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    dispose = _disposed;
    if (!dispose)
    {
        previousDisposable = _disposable;
        _disposable = disposable;
    }
    OSSpinLockUnlock(&_lock);
    
    if (previousDisposable != nil)
        [previousDisposable dispose];
    
    if (dispose)
        [disposable dispose];
#pragma mark clang diagnostic pop

}

- (void)dispose
{
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    id<MTDisposable> disposable = nil;
    
    OSSpinLockLock(&_lock);
    if (!_disposed)
    {
        disposable = _disposable;
        _disposed = true;
    }
    OSSpinLockUnlock(&_lock);
    
    if (disposable != nil)
        [disposable dispose];
#pragma mark clang diagnostic pop

}

@end

@interface MTDisposableSet ()
{
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLock _lock;
    bool _disposed;
    id<MTDisposable> _singleDisposable;
    NSArray *_multipleDisposables;
#pragma mark clang diagnostic pop

}

@end

@implementation MTDisposableSet

- (void)add:(id<MTDisposable>)disposable
{
    if (disposable == nil)
        return;
    
    bool dispose = false;
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    dispose = _disposed;
    if (!dispose)
    {
        if (_multipleDisposables != nil)
        {
            NSMutableArray *multipleDisposables = [[NSMutableArray alloc] initWithArray:_multipleDisposables];
            [multipleDisposables addObject:disposable];
            _multipleDisposables = multipleDisposables;
        }
        else if (_singleDisposable != nil)
        {
            NSMutableArray *multipleDisposables = [[NSMutableArray alloc] initWithObjects:_singleDisposable, disposable, nil];
            _multipleDisposables = multipleDisposables;
            _singleDisposable = nil;
        }
        else
        {
            _singleDisposable = disposable;
        }
    }
    OSSpinLockUnlock(&_lock);
    
    if (dispose)
        [disposable dispose];
#pragma mark clang diagnostic pop

}

- (void)remove:(id<MTDisposable>)disposable {
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    OSSpinLockLock(&_lock);
    if (_multipleDisposables != nil)
    {
        NSMutableArray *multipleDisposables = [[NSMutableArray alloc] initWithArray:_multipleDisposables];
        [multipleDisposables removeObject:disposable];
        _multipleDisposables = multipleDisposables;
    }
    else if (_singleDisposable == disposable)
    {
        _singleDisposable = nil;
    }
    OSSpinLockUnlock(&_lock);
#pragma mark clang diagnostic pop

}

- (void)dispose
{
#pragma mark clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    id<MTDisposable> singleDisposable = nil;
    NSArray *multipleDisposables = nil;
    
    OSSpinLockLock(&_lock);
    if (!_disposed)
    {
        _disposed = true;
        singleDisposable = _singleDisposable;
        multipleDisposables = _multipleDisposables;
        _singleDisposable = nil;
        _multipleDisposables = nil;
    }
    OSSpinLockUnlock(&_lock);
    
    if (singleDisposable != nil)
        [singleDisposable dispose];
    if (multipleDisposables != nil)
    {
        for (id<MTDisposable> disposable in multipleDisposables)
        {
            [disposable dispose];
        }
    }
#pragma mark clang diagnostic pop

}

@end
