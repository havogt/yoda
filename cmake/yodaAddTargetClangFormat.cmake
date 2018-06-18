##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(yodaGetScriptDir)
include(CMakeParseArguments)

#.rst:
# yoda_add_target_clang_format
# ----------------------------------------
#
# Provide a ``format`` target which runs clang-format_ recursively on all files in the provided 
# directories.
#
# .. code-block:: cmake
#
#  yoda_add_target_clang_format(DIRECTORIES PATTERN)
#
# ``DIRECTORIES``
#   Directories to recursively traverse to find all files with extensions matching ``EXTENSION``.
# ``EXTENSION``
#   Extension to match, separated by ``;``. For example: ``".h;.cpp"``. 
#
# .. _clang-format: https://clang.llvm.org/docs/ClangFormat.html
#
function(yoda_add_target_clang_format)
  set(options)
  set(one_value_args)
  set(multi_value_args DIRECTORIES EXTENSION)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
  
  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "yoda_add_target_clang_format: invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT(CLANG-FORMAT_EXECUTABLE))
    return()
  endif()

  yoda_get_script_dir(script_dir)

  # Set configure arguments
  set(CLANG-FORMAT_DIRECTORIES ${ARG_DIRECTORIES})
  set(CLANG-FORMAT_EXTENSION ${ARG_EXTENSION})

  set(input_script 
      ${script_dir}/yodaAddTargetClangFormat-Script.cmake.in)
  set(output_script 
      ${CMAKE_BINARY_DIR}/yoda-cmake/cmake/yodaAddTargetClangFormat-Script-Format.cmake)
  
  configure_file(${input_script} ${output_script} @ONLY)
  
  add_custom_target(format
      COMMAND ${CMAKE_COMMAND} -P "${output_script}"
      COMMENT "Running clang-format"
  )
endfunction()
