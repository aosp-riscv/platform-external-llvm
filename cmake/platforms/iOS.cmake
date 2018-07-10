# Toolchain config for iOS.

SET(CMAKE_SYSTEM_NAME Darwin)
SET(CMAKE_SYSTEM_VERSION 13)
SET(CMAKE_CXX_COMPILER_WORKS True)
SET(CMAKE_C_COMPILER_WORKS True)
SET(IOS True)

if(NOT CMAKE_OSX_SYSROOT)
  execute_process(COMMAND xcodebuild -version -sdk iphoneos Path
    OUTPUT_VARIABLE SDKROOT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  IF(NOT EXISTS ${SDKROOT})
    MESSAGE(FATAL_ERROR "SDKROOT could not be detected!")
  ENDIF()

  message(STATUS "Using SDKROOT ${SDKROOT}")
  set(CMAKE_OSX_SYSROOT ${SDKROOT})
endif()

IF(NOT CMAKE_C_COMPILER)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find clang
   OUTPUT_VARIABLE CMAKE_C_COMPILER
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(STATUS "Using c compiler ${CMAKE_C_COMPILER}")
ENDIF()

IF(NOT CMAKE_CXX_COMPILER)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find clang++
   OUTPUT_VARIABLE CMAKE_CXX_COMPILER
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(STATUS "Using c compiler ${CMAKE_CXX_COMPILER}")
ENDIF()

IF(NOT CMAKE_AR)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find ar
   OUTPUT_VARIABLE CMAKE_AR_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_AR ${CMAKE_AR_val} CACHE FILEPATH "Archiver")
  message(STATUS "Using ar ${CMAKE_AR}")
ENDIF()

IF(NOT CMAKE_RANLIB)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find ranlib
   OUTPUT_VARIABLE CMAKE_RANLIB_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_RANLIB ${CMAKE_RANLIB_val} CACHE FILEPATH "Ranlib")
  message(STATUS "Using ranlib ${CMAKE_RANLIB}")
ENDIF()

IF(NOT CMAKE_STRIP)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find strip
   OUTPUT_VARIABLE CMAKE_STRIP_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_STRIP ${CMAKE_STRIP_val} CACHE FILEPATH "Strip")
  message(STATUS "Using strip ${CMAKE_STRIP}")
ENDIF()

IF(NOT CMAKE_DSYMUTIL)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find dsymutil
   OUTPUT_VARIABLE CMAKE_DSYMUTIL_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_DSYMUTIL ${CMAKE_DSYMUTIL_val} CACHE FILEPATH "Dsymutil")
  message(STATUS "Using dsymutil ${CMAKE_DSYMUTIL}")
ENDIF()

IF(NOT CMAKE_LIBTOOL)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find libtool
   OUTPUT_VARIABLE CMAKE_LIBTOOL_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_LIBTOOL ${CMAKE_LIBTOOL_val} CACHE FILEPATH "Libtool")
  message(STATUS "Using libtool ${CMAKE_LIBTOOL}")
ENDIF()

IF(NOT CMAKE_CODESIGN)
  execute_process(COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find codesign
   OUTPUT_VARIABLE CMAKE_CODESIGN_val
   ERROR_QUIET
   OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_CODESIGN ${CMAKE_CODESIGN_val} CACHE FILEPATH "Codesign")
  message(STATUS "Using codesign ${CMAKE_CODESIGN}")
ENDIF()

IF(NOT CMAKE_CODESIGN_ALLOCATE)
  execute_process(
    COMMAND xcrun -sdk ${CMAKE_OSX_SYSROOT} -find codesign_allocate
    OUTPUT_VARIABLE CMAKE_CODESIGN_ALLOCATE_val
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  SET(CMAKE_CODESIGN_ALLOCATE ${CMAKE_CODESIGN_ALLOCATE_val} CACHE
      FILEPATH "Codesign_Allocate")
  message(STATUS "Using codesign_allocate ${CMAKE_CODESIGN_ALLOCATE}")
ENDIF()
