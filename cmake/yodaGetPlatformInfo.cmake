##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_get_platform_info
# -------------------------------------
#
# Get the identification string of the platform.
#
# .. code-block:: cmake
#
#   yoda_get_platform_info()
#
# The functions defines the following variable:
#
# ``YODA_PLATFORM_STRING``
#   String of the platform.
#
# and conditionally the following:
#
# ``YODA_ON_WIN32``
#   Set to 1 if the platform is Win32-ish
# ``YODA_ON_UNIX``
#   Set to 1 if the platform is Unix-ish
# ``YODA_ON_APPLE``
#   Set to 1 if the platform is Darwin
# ``YODA_ON_LINUX``
#   Set to 1 if the platform is Linux
#
macro(yoda_get_platform_info)
  if(WIN32)
    set(YODA_ON_WIN32 1 CACHE INTERNAL "Platform is Win32-ish" FORCE)
    set(YODA_PLATFORM_STRING "Windows" CACHE INTERNAL "Platform-id string" FORCE)
  elseif(APPLE)
    set(YODA_ON_UNIX 1 CACHE INTERNAL "Platform is Unix-ish" FORCE)
    set(YODA_ON_APPLE 1 CACHE INTERNAL "Platform is Darwin" FORCE)
    set(YODA_PLATFORM_STRING "Darwin" CACHE INTERNAL "Platform-id string" FORCE)
  elseif(UNIX)
    set(YODA_ON_UNIX 1 CACHE INTERNAL "Platform is Unix-ish" FORCE)
    set(YODA_ON_LINUX 1 CACHE INTERNAL "Platform is Linux" FORCE)
    set(YODA_PLATFORM_STRING "Linux" CACHE INTERNAL "Platform-id string" FORCE)
  endif()
endmacro()
