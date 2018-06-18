##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(CMakeParseArguments)

#.rst:
# .. _yoda_export_package:
#
# yoda_export_package
# ---------------------------
#
# Export a package by defining variable for its libraries, include directories, definition and 
# version.
#
# .. code-block:: cmake
#
#   yoda_export_package(NAME FOUND [LIBRARIES] [INCLUDE_DIRS] 
#                          [DEFINITIONS] [VERSION] [EXECUTABLE])
#
# ``NAME``
#   Name of the package.
# ``FOUND``
#   True if the package was found.
# ``LIBRAREIS``
#   List of libraries to link against (optional).
# ``INCLUDE_DIRS``
#   List of include directories required by this package (optional).
# ``DEFINITIONS``
#   List of definitions required by the package (optional).
# ``EXECUTABLE``
#   Exectuable of the package (optional).
# ``VERSION``
#   Version of the package (optional).
#
# The following variables are defined:
#
# ``YODA_<NAME>_FOUND``
#   True if package was found.
# ``YODA_<NAME>_LIBRARIES``
#   Libraries of the package to link against.
# ``YODA_<NAME>_INCLUDE_DIRS``
#   Include directories required by this package.
# ``YODA_<NAME>_DEFINITIONS``
#   Definitions required by the package.
# ``YODA_<NAME>EXECUTABLE``
#   Executable of the package.
# ``YODA_<NAME>_VERSION``
#   Version string of the package.
#
# To create a formatted string of the exported packages :ref:`yoda_create_package_string`.
#
function(yoda_export_package)
  set(options)
  set(one_value_args NAME FOUND VERSION EXECUTABLE)
  set(multi_value_args LIBRARIES INCLUDE_DIRS DEFINITIONS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
  
  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT(DEFINED ARG_NAME))
    message(FATAL_ERROR "yoda_export_package: NAME variable required")
  endif()

  if(NOT(DEFINED ARG_FOUND))
    message(FATAL_ERROR "yoda_export_package: FOUND variable required")
  endif()

  string(TOUPPER ${ARG_NAME} package)

  set("YODA_${package}_FOUND" ${ARG_FOUND} CACHE BOOL "${ARG_PACKAGE} found" FORCE)
  mark_as_advanced("YODA_${package}_FOUND")

  if(DEFINED ARG_LIBRARIES)  
    set("YODA_${package}_LIBRARIES" ${ARG_LIBRARIES} CACHE 
        STRING "Libraries of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("YODA_${package}_LIBRARIES")
  endif()

  if(DEFINED ARG_INCLUDE_DIRS)  
    set("YODA_${package}_INCLUDE_DIRS" ${ARG_INCLUDE_DIRS} CACHE 
        STRING "Include directories of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("YODA_${package}_INCLUDE_DIRS")
  endif()

  if(DEFINED ARG_DEFINITIONS)
    set("YODA_${package}_DEFINITIONS" ${ARG_DEFINITIONS} CACHE 
        STRING "Definitions of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("YODA_${package}_DEFINITIONS")
  endif()

  if(DEFINED ARG_EXECUTABLE)
    set("YODA_${package}_EXECUTABLE" ${ARG_EXECUTABLE} CACHE 
        STRING "Exectuable of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("YODA_${package}_EXECUTABLE")
  endif()

  if(DEFINED ARG_VERSION)
    set("YODA_${package}_VERSION" ${ARG_VERSION} CACHE 
        STRING "Version of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("YODA_${package}_VERSION")
  endif()
endfunction()
