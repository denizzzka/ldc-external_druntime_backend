src = files(
    'src/core/bitop.d',
    'src/core/cpuid.d',
    'src/core/gc/config.d',
    'src/core/gc/gcinterface.d',
    'src/core/gc/registry.d',
    'src/core/demangle.d',
    'src/core/exception.d',
    'src/core/internal/abort.d',
    'src/core/internal/array/appending.d',
    'src/core/internal/array/capacity.d',
    'src/core/internal/array/concatenation.d',
    'src/core/internal/array/equality.d',
    'src/core/internal/array/utils.d',
    'src/core/internal/backtrace/unwind.d',
    'src/core/internal/container/common.d',
    'src/core/internal/convert.d',
    'src/core/internal/container/treap.d',
    'src/core/internal/entrypoint.d',
    'src/core/internal/gc/bits.d',
    'src/core/internal/gc/impl/conservative/gc.d',
    'src/core/internal/gc/impl/manual/gc.d',
    'src/core/internal/gc/impl/proto/gc.d',
    'src/core/internal/gc/os.d',
    'src/core/internal/gc/proxy.d',
    'src/core/internal/lifetime.d',
    'src/core/internal/parseoptions.d',
    'src/core/internal/qsort.d',
    'src/core/internal/spinlock.d',
    'src/core/internal/string.d',
    'src/core/internal/traits.d',
    'src/core/internal/util/array.d',
    'src/core/lifetime.d',
    'src/core/runtime.d',
    'src/core/memory.d',
    'src/core/sync/condition.d',
    'src/core/sync/event.d',
    'src/core/sync/exception.d',
    'src/core/sync/semaphore.d',
    'src/core/time.d',
    'src/core/threadasm.S',
    'src/core/thread/fiber.d',
    'src/core/thread/osthread.d',
    'src/core/thread/threadbase.d',
    'src/core/thread/threadgroup.d',
    'src/core/thread/types.d',
    'src/core/thread/context.d',
    'src/core/thread/package.d',
    'src/core/stdc/fenv.d',
    'src/core/stdc/errno.d',
    'src/core/stdc/stdint.d',
    'src/core/stdc/stdio.d',
    'src/core/stdc/wchar_.d',
    'src/object.d',
    'src/rt/adi.d',
    'src/rt/aaA.d',
    'src/rt/arraycat.d',
    'src/rt/cast_.d',
    'src/rt/config.d',
    'src/rt/critical_.d',
    'src/rt/deh.d',
    'src/rt/deh_win64_posix.d',
    'src/rt/dmain2.d',
    'src/rt/dwarfeh.d',
    'src/rt/ehalloc.d',
    'src/rt/invariant.d',
    'src/rt/lifetime.d',
    'src/rt/memory.d',
    'src/rt/minfo.d',
    'src/rt/monitor_.d',
    'src/rt/profilegc.d',
    'src/rt/tlsgc.d',
    'src/rt/util/typeinfo.d',
    'src/rt/util/utility.d',
    'src/rt/sections.d',
    'src/rt/sections_android.d',
    'src/rt/sections_elf_shared.d',
    'src/rt/sections_ldc.d',
    'src/rt/sections_osx_x86.d',
)

ldc_specific = [
    'src/ldc/sanitizers_optionally_linked.d',
    'src/rt/sections_ldc.d',
]

arm_unwind = declare_dependency(
    sources: ['src/ldc/arm_unwind.c'],
)

use_external_backend = get_option('use_external_backend')
external_backend_D_versions = []

if use_external_backend
    external_backend_D_versions += [
        'DruntimeAbstractRt',
        'CRuntime_Abstract',
        'AsmExternal', #used by fiber module
        #'CoreUnittest',
        'OnlyLowMemUnittest', #disables memory-greedy unittests
        #'SupportSanitizers', #FIXME: remove, for debugging purposes only
    ]
endif

druntime_dep = declare_dependency(
    sources: [src, ldc_specific],
    include_directories: include_directories('src'),
    d_module_versions: external_backend_D_versions,
    dependencies: [
        arm_unwind,
    ],
)
