##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

get_filename_component(__yoda_cmake_script_dir__ ${CMAKE_CURRENT_LIST_FILE} PATH)

#.rst:
# yoda_get_script_dir
# ------------------------
#
# Get the directory of the scripts located ``<yoda-root>/cmake/scripts``.
#
# .. code-block:: cmake
#
#   yoda_get_script_dir(SCRIPT_DIR_VAR)
# 
# * Output arguments:
#
# ``SCRIPT_DIR_VAR``
#   Variable which will contain the script directory on output.
#
# .. note:: This function is for internal use only.
#
function(yoda_get_script_dir SCRIPT_DIR_VAR)
  set(${SCRIPT_DIR_VAR} "${__yoda_cmake_script_dir__}/scripts" PARENT_SCOPE)
endfunction()
