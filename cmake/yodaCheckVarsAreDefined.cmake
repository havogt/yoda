##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_check_vars_are_defined
# -------------------------------
#
# It checks that all the variables within the argument (list) are defined
# It triggers an error if the condition does not hold.
# 
# .. code-block:: cmake
#   
#   yoda_check_vars_are_defined(VARS)
#
# * Input arguments:
#
#  ``VARS:list``
#   list of all variables that should be defined.
#
function(yoda_check_vars_are_defined VARS)

  foreach(arg ${${VARS}})
    if(NOT( DEFINED ${arg}) )
      message(FATAL_ERROR "required variable ${arg} is not defined")
    endif()
  endforeach()

endfunction()

