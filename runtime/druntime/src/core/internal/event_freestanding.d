module core.internal.event_freestanding;

version (FreeStanding):

import core.internal.traits : externDFunc;
import core.time : Duration;

struct Event
{
    private void* evnt;
    private bool clearOnExit;

    nothrow @nogc:

    this(bool manualReset, bool initialState) @safe
    {
        initialize(manualReset, initialState);
    }

    void initialize(bool manualReset, bool initialState) @safe
    in(evnt is null)
    {
        alias createEvent = externDFunc!("core.internal.event_freestanding.createEvent",
            void* function() nothrow @nogc @safe);

        evnt = createEvent();

        clearOnExit = manualReset;

        if(initialState)
            setIfInitialized();
    }

    // copying not allowed, can produce resource leaks
    @disable this(this);
    @disable void opAssign(Event);

    ~this() @safe
    {
        terminate();
    }

    void terminate() @safe
    in(evnt)
    {
        alias terminateEvent = externDFunc!("core.internal.event_freestanding.terminateEvent",
            void function(void*) nothrow @nogc @safe);

        terminateEvent(evnt);

        evnt = null;
    }

    bool setIfInitialized() @safe
    {
        if(evnt is null)
            return false;
        else
        {
            alias setEvent = externDFunc!("core.internal.event_freestanding.setEvent",
                void function(void*) nothrow @nogc @safe);

            setEvent(evnt);

            return true;
        }
    }

    void reset()
    in(evnt)
    {
        alias clearEvent = externDFunc!("core.internal.event_freestanding.clearEvent",
            void function(void*) nothrow @nogc @safe);

        clearEvent(evnt);
    }

    void wait()
    in(evnt)
    {
        alias waitEvent = externDFunc!("core.internal.event_freestanding.waitEvent",
            void function(void*, bool) nothrow @nogc @safe);

        waitEvent(evnt, clearOnExit);
    }

    bool wait(Duration tmout)
    in(!tmout.isNegative)
    in(evnt)
    {
        alias waitEventWithTimeout = externDFunc!("core.internal.event_freestanding.waitEventWithTimeout",
            bool function(void*, bool, Duration) nothrow @nogc @safe);

        return waitEventWithTimeout(evnt, clearOnExit, tmout);
    }
}
