##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_check_required_vars
# -------------------------------
#
# It checks that the list of `REQUIRED_VARS` is contained within the list of `SET_VARS`
# 
# .. code-block:: cmake
#   
#   yoda_check_required_vars(SET_VARS "svars..." REQUIRED_VARS "rvars...")
#
# * Input arguments:
#
#  ``SET_VARS``
#   list of all variables that should contain the list of `REQUIRED_VARS`
#  ``REQUIRED_VARS``
#   list of variables that should be contained in the list of `SET_VARS`
#
function(yoda_check_required_vars)

  cmake_policy(SET CMP0057 NEW)

  set(options)
  set(one_value_args)
  set(multi_value_args SET_VARS REQUIRED_VARS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  foreach(arg ${ARG_REQUIRED_VARS})
    if(NOT("${arg}" IN_LIST ARG_SET_VARS))
      message(FATAL_ERROR "A required variable, ${arg}, is not in present in the list of variables being set: ${ARG_SET_VARS}")
    endif()
  endforeach()

endfunction()

