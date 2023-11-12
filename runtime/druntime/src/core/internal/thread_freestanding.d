module core.internal.thread_freestanding;

version (FreeStanding):

import core.internal.traits : externDFunc;
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

    ref auto _m_sz()
    {
        return m_sz;
    }

    private shared bool m_isRunning;
    //FIXME: allocate and deallocate it!!
    void* taskProperties;

    /// Initializes a thread object which has no associated executable function.
    /// This is used for the main thread initialized in thread_init().
    this(size_t sz = 0) @safe pure nothrow @nogc
    {
    }

    private alias thread_ctor_impl = externDFunc!("core.internal.thread_freestanding.thread_ctor_impl",
        void function(Thread) nothrow @nogc @safe);

    this(void function() fn, size_t sz = 0) @safe nothrow
    in(fn !is null)
    {
        super(fn, sz);

        thread_ctor_impl(this);
    }

    this(void delegate() dg, size_t sz = 0) @safe nothrow
    in(dg !is null)
    {
        super(dg, sz);

        thread_ctor_impl(this);
    }

    this(void function() fn, size_t sz = 0, /* string file = __FILE__, size_t line = __LINE__ */) @safe nothrow;

    this(void delegate() dg, size_t sz = 0, /* string file = __FILE__, size_t line = __LINE__ */) @safe nothrow;

    ~this() nothrow @nogc;

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
