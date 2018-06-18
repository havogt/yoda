##===-------------------------------------------------------------------------------------------===##
##                        _..._                                                          
##                     .-'_..._''.                                    .---._______       
##  __  __   ___     .' .'      '.\  .         /|                 .--.|   |\  ___ `'.    
## |  |/  `.'   `.  / .'           .'|         ||                 |__||   | ' |--.\  \   
## |   .-.  .-.   '. '            <  |         ||                 .--.|   | | |    \  '  
## |  |  |  |  |  || |             | |         ||  __             |  ||   | | |     |  ' 
## |  |  |  |  |  || |             | | .'''-.  ||/'__ '.   _    _ |  ||   | | |     |  | 
## |  |  |  |  |  |. '             | |/.'''. \ |:/`  '. ' | '  / ||  ||   | | |     ' .' 
## |  |  |  |  |  | \ '.          .|  /    | | ||     | |.' | .' ||  ||   | | |___.' /'  
## |__|  |__|  |__|  '. `._____.-'/| |     | | ||\    / '/  | /  ||__||   |/_______.'/   
##                     `-.______ / | |     | | |/\'..' /|   `'.  |    '---'\_______|/    
##                              `  | '.    | '.'  `'-'` '   .'|  '/                      
##                                 '---'   '---'         `-'  `--'                       
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(mchbuildIncludeGuard)
mchbuild_include_guard()

include(CMakeParseArguments)

#.rst:
# .. _mchbuild_export_package:
#
# mchbuild_export_package
# ---------------------------
#
# Export a package by defining variable for its libraries, include directories, definition and 
# version.
#
# .. code-block:: cmake
#
#   mchbuild_export_package(NAME FOUND [LIBRARIES] [INCLUDE_DIRS] 
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
# ``MCHBUILD_<NAME>_FOUND``
#   True if package was found.
# ``MCHBUILD_<NAME>_LIBRARIES``
#   Libraries of the package to link against.
# ``MCHBUILD_<NAME>_INCLUDE_DIRS``
#   Include directories required by this package.
# ``MCHBUILD_<NAME>_DEFINITIONS``
#   Definitions required by the package.
# ``MCHBUILD_<NAME>EXECUTABLE``
#   Executable of the package.
# ``MCHBUILD_<NAME>_VERSION``
#   Version string of the package.
#
# To create a formatted string of the exported packages :ref:`mchbuild_create_package_string`.
#
function(mchbuild_export_package)
  set(options)
  set(one_value_args NAME FOUND VERSION EXECUTABLE)
  set(multi_value_args LIBRARIES INCLUDE_DIRS DEFINITIONS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
  
  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT(DEFINED ARG_NAME))
    message(FATAL_ERROR "mchbuild_export_package: NAME variable required")
  endif()

  if(NOT(DEFINED ARG_FOUND))
    message(FATAL_ERROR "mchbuild_export_package: FOUND variable required")
  endif()

  string(TOUPPER ${ARG_NAME} package)

  set("MCHBUILD_${package}_FOUND" ${ARG_FOUND} CACHE BOOL "${ARG_PACKAGE} found" FORCE)
  mark_as_advanced("MCHBUILD_${package}_FOUND")

  if(DEFINED ARG_LIBRARIES)  
    set("MCHBUILD_${package}_LIBRARIES" ${ARG_LIBRARIES} CACHE 
        STRING "Libraries of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("MCHBUILD_${package}_LIBRARIES")
  endif()

  if(DEFINED ARG_INCLUDE_DIRS)  
    set("MCHBUILD_${package}_INCLUDE_DIRS" ${ARG_INCLUDE_DIRS} CACHE 
        STRING "Include directories of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("MCHBUILD_${package}_INCLUDE_DIRS")
  endif()

  if(DEFINED ARG_DEFINITIONS)
    set("MCHBUILD_${package}_DEFINITIONS" ${ARG_DEFINITIONS} CACHE 
        STRING "Definitions of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("MCHBUILD_${package}_DEFINITIONS")
  endif()

  if(DEFINED ARG_EXECUTABLE)
    set("MCHBUILD_${package}_EXECUTABLE" ${ARG_EXECUTABLE} CACHE 
        STRING "Exectuable of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("MCHBUILD_${package}_EXECUTABLE")
  endif()

  if(DEFINED ARG_VERSION)
    set("MCHBUILD_${package}_VERSION" ${ARG_VERSION} CACHE 
        STRING "Version of package: ${ARG_PACKAGE}" FORCE)
    mark_as_advanced("MCHBUILD_${package}_VERSION")
  endif()
endfunction()
