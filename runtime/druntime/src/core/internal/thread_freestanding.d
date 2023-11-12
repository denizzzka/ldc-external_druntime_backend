module core.internal.thread_freestanding;

version (FreeStanding):

import core.internal.traits : externDFunc;
import core.sync.event: Event;
import core.time : Duration;
import core.thread.threadbase : ThreadBase;
import core.thread.types : ThreadID;

class Thread : ThreadBase
{
    override final void run()
    {
        super.run();
    }

    @nogc:
    nothrow:

    struct TaskProperties
    {
        void* sys_task_handler;
        Event joinEvent;
        void* stackBuff;
    }

    ref auto _m_sz()
    {
        return m_sz;
    }

    TaskProperties taskProperties;
    private shared bool m_isRunning;

    /// Initializes a thread object which has no associated executable function.
    /// This is used for the main thread initialized in thread_init().
    this(size_t sz = 0) @safe pure nothrow @nogc
    {
    }

    private alias initTaskProperties = externDFunc!("core.internal.thread_freestanding.initTaskProperties",
        void function(Thread) nothrow @nogc @safe);

    this(void function() fn, size_t sz = 0) @safe nothrow
    in(fn !is null)
    {
        super(fn, sz);

        initTaskProperties(this);
        taskProperties.joinEvent = Event(true, false);
    }

    this(void delegate() dg, size_t sz = 0) @safe nothrow
    in(dg !is null)
    {
        super(dg, sz);

        initTaskProperties(this);
        taskProperties.joinEvent = Event(true, false);
    }

    ~this() nothrow @nogc
    {
        import core.stdc.stdlib: free;

        if(taskProperties.stackBuff) // not main thread
            free(taskProperties.stackBuff);

        destructBeforeDtor();
    }

    extern(D) private void initTaskProperties() @safe nothrow;

    void initDataStorage() nothrow
    {
        assert(m_curr is &m_main);

        assert(m_main.bstack);
        m_main.tstack = m_main.bstack;

        tlsGCdataInit();
    }

    final Thread start() nothrow;

    static Thread getThis() @safe
    {
        return cast(Thread) ThreadBase.getThis;
    }

    import core.atomic: atomicStore, atomicLoad, MemoryOrder;

    void isRunning(bool status) @property nothrow @nogc
    {
        atomicStore!(MemoryOrder.raw)(m_isRunning, status);
    }

    override final @property bool isRunning() nothrow @nogc
    {
        if (!super.isRunning())
            return false;

        return atomicLoad(m_isRunning);
    }

    //
    // Remove a thread from the global thread list.
    //
    static void remove(Thread t) nothrow @nogc
    {
        assert(false, "Not implemented");
    }

    override final Throwable join( bool rethrow = true );

    static void sleep(Duration val);

    static void yield();
}
