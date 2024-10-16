#include "ruby.h"

#if defined(__APPLE__)
#include <mach/mach_time.h>
#elif defined(_WIN32)
#include <profileapi.h>
#include <winnt.h>
#define COMMON_QPF 10000000LL
#else
#include <time.h>
#endif

#define S_IN_NS 1000000000LL

long long monotonic_get_monotonic_time() {
#if defined(__APPLE__)
  return mach_continuous_time();
#elif defined(_WIN32)

  LARGE_INTEGER qpf;
  QueryPerformanceFrequency(&qpf);

  LARGE_INTEGER qpc;
  QueryPerformanceCounter(&qpc);

  // https://github.com/microsoft/STL/blob/785143a0c73f030238ef618890fd4d6ae2b3a3a0/stl/inc/chrono#L694-L701
  if (qpf.QuadPart == COMMON_QPF) {
    return qpc.QuadPart * (S_IN_NS / COMMON_QPF);
  }

  long long nanoseconds = qpc.QuadPart * S_IN_NS;
  nanoseconds /= qpf.QuadPart;
  return nanoseconds;
#else
  struct timespec ts;
  clock_gettime(CLOCK_BOOTTIME, &ts);
  return ts.tv_sec * S_IN_NS + ts.tv_nsec;
#endif
}

VALUE monotonic_get_monotonic_time_ext() {
  return LL2NUM(monotonic_get_monotonic_time());
}

void Init_monotonic() {
  VALUE mod = rb_define_module("Monotonic");
  rb_define_singleton_method(mod, "monotonic_time",
                             monotonic_get_monotonic_time_ext, 0);
}
