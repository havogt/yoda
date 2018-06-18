##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(CheckCXXCompilerFlag)

#.rst:
# yoda_check_cxx_flag
# -------------------------------
#
# Test if the C++ compiler flag is supported.
#
# .. code-block:: cmake
#
#   yoda_check_cxx_flag(FLAG NAME)
#
# ``FLAG``
#   Compiler flag to check (e.g -O3).
# ``NAME``
#   Name of the check (e.g HAVE_GCC_O3).
#
macro(yoda_check_cxx_flag FLAG NAME)
  check_cxx_compiler_flag("${FLAG}" ${NAME})
endmacro()
