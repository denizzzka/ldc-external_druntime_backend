/+
REQUIRED_ARGS: -o- -HC
TEST_OUTPUT:
---
// Automatically generated by Digital Mars D Compiler

#pragma once

#include <assert.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>

class ExternDClass;
struct ExternDStruct2;
struct ExternDStruct3;

struct ExternDStruct final
{
    int32_t i;
    double d;
    ExternDStruct() :
        i(),
        d()
    {
    }
    ExternDStruct(int32_t i, double d = NAN) :
        i(i),
        d(d)
        {}
};

enum class ExternDEnum
{
    A = 0,
};

template <>
struct ExternDStructTemplate final
{
    int32_t i;
    double d;
    ExternDStructTemplate()
    {
    }
};

class Object
{
    virtual void __vtable_slot_0();
    virtual void __vtable_slot_1();
    virtual void __vtable_slot_2();
    virtual void __vtable_slot_3();
public:
    class Monitor
    {
        virtual void __vtable_slot_4();
        virtual void __vtable_slot_5();
    };

};

class ExternDClass : public Object
{
public:
    int32_t i;
    double d;
};

struct ExternDStruct2 final
{
    int32_t doStuff();
    ExternDStruct2()
    {
    }
};

struct ExternDStruct3 final
{
    int32_t a;
    ExternDStruct3() :
        a()
    {
    }
    ExternDStruct3(int32_t a) :
        a(a)
        {}
};

namespace ExternDEnum2
{
    static ExternDStruct3 const A = ExternDStruct3(1);
};

struct ExternCppStruct final
{
    ExternDStruct s;
    ExternDEnum e;
    ExternDStructTemplate< > st;
    ExternCppStruct() :
        s(),
        st()
    {
    }
    ExternCppStruct(ExternDStruct s, ExternDEnum e = (ExternDEnum)0, ExternDStructTemplate< > st = ExternDStructTemplate< >()) :
        s(s),
        e(e),
        st(st)
        {}
};

extern ExternDClass* globalC;

extern void foo(int32_t arg = globalC.i);

extern ExternDStruct2* globalS2;

extern void bar(int32_t arg = globalS2->doStuff());

extern /* ExternDEnum2 */ ExternDStruct3* globalE2;

extern void baz(int32_t arg = globalE2->a);
---

Known issues:
- class declarations must be emitted on member access
+/

// extern(D) symbols are ignored upon first visit but required later

struct ExternDStruct
{
	int i;
	double d;

	// None of these can be emitted due to the mismatched mangling
	static double staticDouble;
	static shared double staticSharedDouble;
	__gshared double sharedDouble;
}

struct ExternDStruct2
{
	extern(C++) int doStuff()
    {
        return 1;
    }
}

struct ExternDStruct3
{
	int a;
}

class ExternDClass
{
	int i;
	double d;
}

enum ExternDEnum
{
	A
}

enum ExternDEnum2 : ExternDStruct3
{
	A = ExternDStruct3(1)
}

struct ExternDStructTemplate()
{
	int i;
	double d;
}

extern (C++):

struct ExternCppStruct
{
	ExternDStruct s;
	ExternDEnum e;
	ExternDStructTemplate!() st;
}

__gshared ExternDClass globalC;

void foo(int arg = globalC.i) {}

__gshared ExternDStruct2* globalS2;

void bar(int arg = globalS2.doStuff()) {}

__gshared ExternDEnum2* globalE2;

void baz(int arg = globalE2.a) {}
