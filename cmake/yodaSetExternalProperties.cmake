##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(CMakeParseArguments)

#.rst:
# yoda_set_external_properties
# ------------------------------------
#
# Set directories associated to an external project used by yoda. 
# The function is used to impose a convention for directories of external projects
# where they will be installed and built. 
#
# .. code-block:: cmake
#
#   yoda_set_external_properties(NAME <pkg> INSTALL_DIR <install_dir_var> 
#      SOURCE_DIR <source_dir_var> BINARY_DIR <binary_dir_var>)
#
# ``NAME``
# Name of the package
#
# ``INSTALL_DIR`` 
# variable that will hold the installation directory
#
# ``SOURCE_DIR`` 
# variable that will hold the source directory
#
# ``BINARY_DIR`` 
# variable that will hold the building directory
#
function(yoda_set_external_properties)
  set(options)
  set(one_value_args NAME INSTALL_DIR SOURCE_DIR BINARY_DIR)
  set(multi_value_args)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(DEFINED ARG_INSTALL_DIR) 
    set(${ARG_INSTALL_DIR} "${PROJECT_BINARY_DIR}/prefix/${ARG_NAME}" PARENT_SCOPE)
  endif()
  if(DEFINED ARG_SOURCE_DIR) 
    set(${ARG_SOURCE_DIR} "${PROJECT_BINARY_DIR}/${ARG_NAME}-prefix/src/${ARG_NAME}" PARENT_SCOPE)
  endif()
  #Assuming we always use the prefix mode 
  if(DEFINED ARG_BINARY_DIR)
    set(${ARG_BINARY_DIR} "${PROJECT_BINARY_DIR}/${ARG_NAME}-prefix/src/${ARG_NAME}-build/" PARENT_SCOPE)
  endif()


endfunction()
