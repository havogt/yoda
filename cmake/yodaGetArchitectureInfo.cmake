##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_get_architecture_info
# -------------------------------
#
# Get the identification of the architecture.
#
# .. code-block:: cmake
#
#   yoda_get_architecture_info()
#
# The functions defines the following variable:
#
# ``YODA_ARCHITECTURE_STRING``
#   String of the architecture.
#
macro(yoda_get_architecture_info)
  set(YODA_ARCHITECTURE_STRING "${CMAKE_SYSTEM_PROCESSOR}" 
    CACHE INTERNAL "Architecture string" FORCE)
endmacro()
