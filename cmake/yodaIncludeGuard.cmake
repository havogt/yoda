##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

#.rst:
# yoda_include_guard
# ----------------------
#
# Prevent frequently-included CMake files from being re-parsed multiple times.
#
# .. code-block:: cmake
#
#   yoda_include_guard()
#
macro(yoda_include_guard)
  if(DEFINED "__YODA_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}")
    return()
  endif(DEFINED "__YODA_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}")

  set("__YODA_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}" 1)
endmacro()
