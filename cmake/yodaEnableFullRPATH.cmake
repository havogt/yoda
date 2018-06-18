##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

#.rst:
# yoda_enable_full_rpath
# --------------------------------
#
# Enable full RPATH_ support.
#
# .. code-block:: cmake
#
#   yoda_enable_full_rpath(LIB_PATH)
#
# ``LIB_PATH``
#   Install path for libraries (e.g `/libraries/necessarylib/lib`).
#
# .. _RPATH: https://cmake.org/Wiki/CMake_RPATH_handling
#
macro(yoda_enable_full_rpath LIB_PATH)
  # Use, i.e. don't skip the full RPATH for the build tree
  set(CMAKE_SKIP_BUILD_RPATH FALSE)

  # When building, don't use the install RPATH already (but later on when installing)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 

  set(CMAKE_INSTALL_RPATH "${LIB_PATH}")
  set(CMAKE_MACOSX_RPATH "${CMAKE_INSTALL_RPATH}")

  # Add the automatically determined parts of the RPATH which point to directories outside the 
  # build tree to the install RPATH
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

endmacro()
