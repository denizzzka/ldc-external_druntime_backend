module core.internal.semaphore_freestanding;

version (FreeStanding):

import core.internal.traits : externDFunc;
import core.sync.exception: SyncError;

class Semaphore
{
    private shared void* m_hndl;

    void wait()
    {
        if(!waitOrError())
            throw new SyncError("Unable to wait for semaphore");
    }

    void notify()
    {
        if(!notifyOrError())
            throw new SyncError("Unable to notify semaphore");
    }

    nothrow @nogc:

    this(size_t initialCount = 0)
    {
        alias createCountingSemaphore = externDFunc!("core.internal.semaphore_freestanding.createCountingSemaphore",
            shared(void)* function(size_t) nothrow @nogc);

        m_hndl = createCountingSemaphore(initialCount);
    }

    ~this()
    {
        alias deleteCountingSemaphore = externDFunc!("core.internal.semaphore_freestanding.deleteCountingSemaphore",
            void function(shared(void)*) nothrow @nogc);

        deleteCountingSemaphore(m_hndl);

        debug m_hndl = null;
    }

    bool waitOrError()
    {
        alias waitCountingSemaphore = externDFunc!("core.internal.semaphore_freestanding.waitCountingSemaphore",
            bool function(shared(void)*) nothrow @nogc);

        return waitCountingSemaphore(m_hndl);
    }

    import core.time : Duration;

    bool wait(Duration period)
    in(!period.isNegative)
    {
        alias waitCountingSemaphoreWithTimeout = externDFunc!("core.internal.semaphore_freestanding.waitCountingSemaphoreWithTimeout",
            bool function(shared(void)*, Duration) nothrow @nogc);

        return waitCountingSemaphoreWithTimeout(m_hndl, period);
    }

    bool tryWait()
    {
        return wait(Duration.zero);
    }

    bool notifyOrError()
    {
        alias giveCountingSemaphore = externDFunc!("core.internal.semaphore_freestanding.giveCountingSemaphore",
            bool function(shared(void)*) nothrow @nogc);

        return giveCountingSemaphore(m_hndl);
    }
}
