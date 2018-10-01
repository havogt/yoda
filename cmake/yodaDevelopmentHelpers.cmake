##===-------------------------------------------------------------------------------------------===##
##                        _..._                                                          
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

# Collection of helpers for development builds
# -----------------------------

# if enabled:
# - The CMake config will set include paths to point to the src location, not the installation path,
#   to help IDEs to find the correct location, i.e. the src, in a multi-project setup.
option(YODA_DEVELOPMENT_BUILD "If enabled, yoda will set options for development, e.g. exports include directories to point to src instead of install path" OFF)

