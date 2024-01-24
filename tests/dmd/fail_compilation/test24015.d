/* REQUIRED_ARGS: -preview=dip1000
 * TEST_OUTPUT:
---
fail_compilation/test24015.d(19): Error: scope variable `v` assigned to non-scope parameter `...` calling `jer`
---
*/

// https://issues.dlang.org/show_bug.cgi?id=24105

@safe:

extern (C) void ben(int i, scope ...);

extern (C) void jer(int i, ...);

void bar(scope const char* v)
{
    ben(3, v);
    jer(3, v);
}
