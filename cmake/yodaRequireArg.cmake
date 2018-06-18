##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_require_arg
# ----------------------
#
# It errors if the argument passed is not defined.
# This function is used as a helper for other functions to ensure
# that required arguments are passed by user call
#
# .. code-block:: cmake
#
#   yoda_require_arg(ARG)
#
# ``ARG``
#  - argument that is required
#

function(yoda_require_arg ARG)
  if(ARGN STREQUAL "")
    message(FATAL_ERROR "missing required argument ${ARG}")
  endif()
endfunction()
