##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(yodaCheckCXXFlag)

#.rst:
# yoda_check_and_set_cxx_flag
# --------------------------------------
#
# Test if the C++ compiler flag is supported and if so, add it to the ``CMAKE_CXX_FLAGS``.
#
# .. code-block:: cmake
#
#   yoda_check_and_set_cxx_flag(FLAG NAME)
#
# ``FLAG``
#   Compiler flag to check (e.g -O3).
# ``NAME``
#   Name of the check (e.g HAVE_GCC_O3).
#
macro(yoda_check_and_set_cxx_flag FLAG NAME)
  yoda_check_cxx_flag("${FLAG}" ${NAME})
  if(${NAME})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAG}")
  endif()
endmacro()
