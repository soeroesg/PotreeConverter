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

