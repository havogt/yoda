##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaGetCacheVariables)

#.rst:
# yoda_generate_cmake_script
# --------------------------------
#
# Create bash script for re-invoking CMake in the build directory. 
#
# .. code-block:: cmake
#
#   yoda_generate_cmake_script(CMAKE_LISTS_DIR BUILD_DIR)
#
# * Input arguments
#
#   ``CMAKE_LISTS_DIR:PATH``
#    - Path to the CMakeLists.txt to invoke
#   ``BUILD_DIR:PATH``
#    - Directory to install the script
#
macro(yoda_generate_cmake_script CMAKE_LISTS_DIR BUILD_DIR)
  set(script_args)
  set(_CMAKE_ARGS_)
  yoda_get_cache_variables(_CMAKE_ARGS_)
  foreach(arg ${_CMAKE_ARGS_})
    string(REGEX MATCH "^(.*)=+(.*)$" dummy ${arg})
    if(NOT(CMAKE_MATCH_1) AND NOT(CMAKE_MATCH_2))
      set(script_args "${script_args} ${arg}")
    else()
      # Value of an option should be quoated
      set(script_args "${script_args} ${CMAKE_MATCH_1}=\"${CMAKE_MATCH_2}\"")
    endif()
  endforeach()
 
  if(NOT ${CMAKE_GENERATOR} STREQUAL "") 
    set(script_args "-G \"${CMAKE_GENERATOR}\" ${script_args}")
  endif()

  file(WRITE ${BUILD_DIR}/rerun-cmake.sh 
       "#!/usr/bin/env bash\n${CMAKE_COMMAND} ${CMAKE_LISTS_DIR} ${script_args}\n")
endmacro()
