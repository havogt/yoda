##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_export_options
# -------------------------
#
# Export a list of options in the variable ``<NAME>_OPTIONS`` which can be accessed by meta
# projects.
# 
# .. code-block:: cmake
#
#   yoda_export_options(NAME ARGN)
#
# ``NAME``
#   Prefix of the options list.
# ``ARGN``
#   List of option names to export.
#
macro(yoda_export_options NAME)
  set("${NAME}_OPTIONS" "" CACHE INTERNAL "Options of ${NAME}" FORCE)
  foreach(arg ${ARGN})
    list(APPEND "${NAME}_OPTIONS" "${arg}")
  endforeach()
endmacro()
