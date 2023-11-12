module core.internal.monitor_freestanding;

version (FreeStanding):

import core.exception;
import core.internal.traits : externDFunc;

nothrow:
@nogc:

private alias MonitorMutex = shared(void)*;
alias Mutex = MonitorMutex;

void initMutex(MonitorMutex* mtx)
{
    alias createMutex = externDFunc!("core.internal.mutex_freestanding.createMutex",
        MonitorMutex function() nothrow @nogc);

    *mtx = createMutex();

    if(*mtx is null)
        onOutOfMemoryError();
}

void destroyMutex(MonitorMutex* mtx)
{
    alias deleteMutex = externDFunc!("core.internal.mutex_freestanding.deleteMutex",
        void function(MonitorMutex) nothrow @nogc);

    deleteMutex(*mtx);
}

void lockMutex(MonitorMutex* mtx)
{
    alias takeMutex = externDFunc!("core.internal.mutex_freestanding.takeMutex",
        bool function(MonitorMutex) nothrow @nogc);

    if(!takeMutex(*mtx))
        onInvalidMemoryOperationError();
}

void unlockMutex(MonitorMutex* mtx)
{
    alias giveMutex = externDFunc!("core.internal.mutex_freestanding.giveMutex",
        bool function(shared void*) nothrow @nogc);

    if(!giveMutex(*mtx))
        onInvalidMemoryOperationError();
}
