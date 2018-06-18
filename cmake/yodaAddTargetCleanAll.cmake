##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(yodaGetScriptDir)

#.rst:
# yoda_add_target_clean_all
# -------------------------------
#
# Provide a ``clean-all`` target which clears the CMake cache and all related CMake files and 
# directories. This effectively removes the following files/directories:
#
#    - ``${CMAKE_BINARY_DIR}/CMakeCache.txt``
#    - ``${CMAKE_BINARY_DIR}/Makefile``
#    - ``${CMAKE_BINARY_DIR}/CTestTestfile.cmake``
#    - ``${CMAKE_BINARY_DIR}/cmake_install.cmake``
#    - ``${CMAKE_BINARY_DIR}/CMakeFiles``
#
# .. code-block:: cmake
#
#  yoda_add_target_clean_all([dirs...])
#
# ``dirs``
#   Addtional files or directories to remove.
#
set(YODA_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}" INTERNAL)

function(yoda_add_target_clean_all)
  yoda_get_script_dir(script_dir)
  set(yoda_add_target_clean_all_extra_args ${ARGN})

  set(input_script ${script_dir}/yodaAddTargetCleanAll-Script.cmake.in)
  set(output_script ${CMAKE_BINARY_DIR}/yoda-cmake/cmake/yodaAddTargetCleanAll-Script.cmake)

  # Configure the script
  configure_file(${input_script} ${output_script} @ONLY)

  add_custom_target(clean-all
      COMMAND ${CMAKE_MAKE_PROGRAM} clean
      COMMAND ${CMAKE_COMMAND} -P "${output_script}"
      COMMENT "Removing CMake related files"
  )
endfunction()
