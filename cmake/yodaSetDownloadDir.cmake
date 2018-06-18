##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

#.rst:
# yoda_set_download_dir
# ----------------------------
#
# This script defines a YODA_DOWNLOAD_DIR variable, if it's not already defined.
#
# Cache the downloads in YODA_DOWNLOAD_DIR if it's defined. Otherwise, use the user's typical 
# Downloads directory, if it already exists. Otherwise, use a Downloads subdir in the build tree.
#
macro(yoda_set_download_dir)
  if(NOT DEFINED YODA_DOWNLOAD_DIR)
    if(NOT "$ENV{HOME}" STREQUAL "" AND EXISTS "$ENV{HOME}/Downloads")
      set(YODA_DOWNLOAD_DIR "$ENV{HOME}/Downloads")
    elseif(NOT "$ENV{USERPROFILE}" STREQUAL "" AND EXISTS "$ENV{USERPROFILE}/Downloads")
      set(YODA_DOWNLOAD_DIR "$ENV{USERPROFILE}/Downloads")
    elseif(NOT "${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "")
      set(YODA_DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/Downloads")
    else()
      message(FATAL_ERROR "unexpectedly empty CMAKE_CURRENT_BINARY_DIR")
    endif()
    string(REPLACE "\\" "/" YODA_DOWNLOAD_DIR "${YODA_DOWNLOAD_DIR}")
  endif()

  file(MAKE_DIRECTORY "${YODA_DOWNLOAD_DIR}")
  if(NOT EXISTS "${YODA_DOWNLOAD_DIR}")
    message(FATAL_ERROR "could not find or make download directory")
  endif()
endmacro()
