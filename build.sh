mkdir build
cd build
cmake .. \
    -DBROTLI_DISABLE_TESTS=TRUE \
    -DTHREADS_PREFER_PTHREADS_FLAG=TRUE \
    -DCMAKE_THREAD_PREFER_PTHREADS=TRUE \
    -DCMAKE_THREAD_LIBS_INIT="-lpthread" \
    -DCMAKE_HAVE_THREADS_LIBRARY=1 \
    -DCMAKE_USE_WIN32_THREADS_INIT=0 \
    -DCMAKE_USE_PTHREADS_INIT=1 \
    -DCMAKE_MODULE_PATH=../../cmake

# Note:
# Ubuntu 18 comes with CMake 3.10 as of Jan 2022
# TBB and Threads libraries are not found by CMake.
# The *THREAD* variables above help to find phtreads for Threads
# The CMAKE_MODULE_PATH can point to a directory containing FindTBB.cmake
# If FindTBB does not work, commenting out TBB in CMakeLists will disable TBB completely

