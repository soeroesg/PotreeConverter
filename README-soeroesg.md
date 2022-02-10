Changes performed to be able to build PotreeConverter on Ubuntu 18 (CMake 3.10, GCC 7.5, C++17)

 * changed `cmake_minimum_required` to 3.10 in all CMakeLists.txt
 * changed `CMAKE_CXX_STANDARD` 20 to 17 in all CMakeLists.txt
 * in Converter/libs/laszip/CMakeLists.txt, changed `add_compile_definitions(***)` to `target_compile_definitions(laszip PUBLIC ***)`
 * added cmake argument `-DBROTLI_DISABLE_TESTS=TRUE` to avoid problems that the Brotli test files do no exist
 * to avoid the error "Could not find package Threads", we can enforce to use pthreads by adding cmake definitions `-DTHREADS_PREFER_PTHREADS_FLAG=TRUE -DCMAKE_THREAD_PREFER_PTHREADS=TRUE -DCMAKE_THREAD_LIBS_INIT="-lpthread" -DCMAKE_HAVE_THREADS_LIBRARY=1 -DCMAKE_USE_WIN32_THREADS_INIT=0 -DCMAKE_USE_PTHREADS_INIT=1`
 * if TBB (Intel Threading Building Blocks) is not found, first install it (`sudo apt install libtbb-dev`) and then add the FindTBB.cmake file to the cmake module path: `-DCMAKE_MODULE_PATH=../../cmake`. See also the issue [here](https://github.com/potree/PotreeConverter/issues/447)

 * lasreader.hpp: No such file or directory. The laszip project must link with LASlib. Clone, build, and install from [here](https://github.com/LAStools/LAStools). Added this at the end of the laszip CMakeLists.txt: 
```
if(UNIX)
  find_package(LASlib REQUIRED)
  target_link_libraries(laszip PUBLIC LASlib)
endif()
```

 * Vector3.h: std::setprecision is not known. #include <iomanip>

 * #include filesystem No such file or directory. Removed all such lines, and extended the unsuck/filesystem.hpp with the following:
```
#ifndef __has_include
  static_assert(false, "__has_include macro not supported by the compiler")
#endif
#if __has_include(<filesystem>)
  #pragma message("using std::filesystem")
  #include <filesystem>
  namespace fs = std::filesystem;
  // NOTE: may need to link with -lstdc++fs on GNU C++ < 9.0
#elif __has_include(<experimental/filesystem>)
  #pragma message("using std::experimental::filesystem")
  #include <experimental/filesystem>
  namespace fs = std::experimental::filesystem;
#else
  #pragma error("filesystem header not found")
#endif
```
 * fs::weakly_canonical() is not defined. As a quick hack, replace it with fs::canonical()

 * header <execution> is missing. This requires at least GCC 9.1. We check for availability:
```
#if __has_include(<execution>)
  #include <execution>
#endif
```
Rewritten to serial execution at the beginning of the for loop:
```
#if __has_include(<execution>)
        auto parallel = std::execution::par;
        for_each(parallel, sources.begin(), sources.end(), [...](Source source) {
#else
        for (auto source : sources) {
#endif
// ...
// and at the end of the for loop:
#if __has_include(<execution>)
        });
#else
    }
#endif
```

 * And execution in the sort() method:
```
#if __has_include(<execution>)
            auto parallel = std::execution::par_unseq;
            std::sort(parallel, points.begin(), points.end(), [center](Point a, Point b) -> bool {
#else
            std::sort(points.begin(), points.end(), [center](Point a, Point b) -> bool {
#endif
```


