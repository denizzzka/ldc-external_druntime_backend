module core.internal.mutex_freestanding;

version (FreeStanding):

import core.internal.traits : externDFunc;
import object;

@nogc:

class Mutex : Object.Monitor
{
    import core.sync.exception;

    private shared void* mtx = void;

    this() @nogc nothrow
    {
        alias createRecursiveMutex = externDFunc!("core.internal.mutex_freestanding.createRecursiveMutex",
            shared(void)* function() nothrow @nogc);

        mtx = createRecursiveMutex();
    }

    this() @nogc shared
    {
        assert(false);
    }

    ~this() @nogc nothrow
    {
        alias deleteRecursiveMutex = externDFunc!("core.internal.mutex_freestanding.deleteRecursiveMutex",
            void function(shared void*) nothrow @nogc);

        deleteRecursiveMutex(mtx);
    }

    final void lock_nothrow(this Q)() nothrow @trusted @nogc
    if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        alias takeMutexRecursive = externDFunc!("core.internal.mutex_freestanding.takeMutexRecursive",
            bool function(shared void*) nothrow @nogc);

        // Infinity wait
        if(takeMutexRecursive(mtx) != true)
        {
            SyncError syncErr = cast(SyncError) cast(void*) typeid(SyncError).initializer;
            syncErr.msg = "Unable to lock mutex.";
            throw syncErr;
        }
    }

    final void unlock_nothrow(this Q)() nothrow @trusted @nogc
    if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        alias giveMutexRecursive = externDFunc!("core.internal.mutex_freestanding.giveMutexRecursive",
            bool function(shared void*) nothrow @nogc);

        if(giveMutexRecursive(mtx) != true)
        {
            SyncError syncErr = cast(SyncError) cast(void*) typeid(SyncError).initializer;
            syncErr.msg = "Unable to unlock mutex.";
            throw syncErr;
        }
    }

    @trusted void lock()
    {
        lock_nothrow();
    }

    /// ditto
    @trusted void lock() shared
    {
        lock_nothrow();
    }

    @trusted void unlock()
    {
        unlock_nothrow();
    }

    /// ditto
    @trusted void unlock() shared
    {
        unlock_nothrow();
    }
}
