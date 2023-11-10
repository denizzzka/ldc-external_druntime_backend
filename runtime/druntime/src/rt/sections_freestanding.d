module rt.sections_freestanding;

// These values described in almost every linker script
extern(C) extern __gshared void* _data;
extern(C) extern __gshared void* _ebss;

extern(C) extern __gshared void* _tdata;
extern(C) extern __gshared void* _tdata_size;
extern(C) extern __gshared void* _tbss;
extern(C) extern __gshared void* _tbss_size;

struct TLSParams
{
    void* tdata_start;
    size_t tdata_size;
    void* tbss_start;
    size_t tbss_size;
    size_t full_tls_size;
}

TLSParams getTLSParams() nothrow @nogc
{
    auto tdata_start = cast(void*)&_tdata;
    auto tbss_start = cast(void*)&_tbss;
    size_t tdata_size = cast(size_t)&_tdata_size;
    size_t tbss_size = cast(size_t)&_tbss_size;
    size_t full_tls_size = tdata_size + tbss_size;

    assert(tbss_size > 1);

    return TLSParams(
        tdata_start,
        tdata_size,
        tbss_start,
        tbss_size,
        full_tls_size
    );
}

void ctorsDtorsWarning() nothrow
{
    static assert("Deprecation 16211");
/*
    fprintf(stderr, "Deprecation 16211 warning:\n"
        ~ "A cycle has been detected in your program that was undetected prior to DMD\n"
        ~ "2.072. This program will continue, but will not operate when using DMD 2.074\n"
        ~ "to compile. Use runtime option --DRT-oncycle=print to see the cycle details.\n");
 */
}
