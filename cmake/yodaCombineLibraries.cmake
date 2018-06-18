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
include(mchbuildRequireArg)

#.rst:
# mchbuild_combine_libraries
# -----------------------------------
#
# Combine multiple object libraries to a single static and, if ``BUILD_SHARED_LIBS`` is ON, shared 
# library. The CMake target of the library is ``<NAME>Static`` and ``<NAME>Shared`` respectively.
# This will also provide an install traget for the libraries as well as an export via 
# ``<NAME>Targets``.
#
# .. code-block:: cmake
#
#   mchbuild_combine_libraries(NAME OBJECTS DEPENDS)
#
# ``NAME``
#   Name of the library.
# ``OBJECTS``
#   Object libraries to combine (see :ref:`mchbuild_add_library`).
# ``INSTALL_DESTINATION``
#   Destition (relative to ``CMAKE_INSTALL_PREFIX``) to install the libraries.
# ``DEPENDS`` [optional]
#   List of external libraries and/or CMake targets treated as dependencies of the library.
#
function(mchbuild_combine_libraries)
  set(options)
  set(one_value_args NAME INSTALL_DESTINATION VERSION)
  set(multi_value_args OBJECTS DEPENDS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  mchbuild_require_arg("VERSION" ${ARG_VERSION}) 
  mchbuild_require_arg("INSTALL_DESTINATION" ${ARG_INSTALL_DESTINATION})

  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "mchbuild_combine_libraries: invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT("${ARG_OBJECTS}" STREQUAL ""))
    set(object_sources)
    foreach(object ${ARG_OBJECTS})
      list(APPEND object_sources $<TARGET_OBJECTS:${object}>)
    endforeach()
  endif()

  # Add static library
  add_library(${ARG_NAME}Static STATIC ${object_sources})
  target_link_libraries(${ARG_NAME}Static PUBLIC ${ARG_DEPENDS})

  set_target_properties(${ARG_NAME}Static PROPERTIES OUTPUT_NAME ${ARG_NAME})
  set_target_properties(${ARG_NAME}Static PROPERTIES VERSION ${ARG_VERSION})

  install(TARGETS ${ARG_NAME}Static 
          DESTINATION ${ARG_INSTALL_DESTINATION} 
          EXPORT ${ARG_NAME}Targets)
  
  # Add shared library
  if(BUILD_SHARED_LIBS)
    add_library(${ARG_NAME}Shared SHARED ${object_sources})
    target_link_libraries(${ARG_NAME}Shared PUBLIC ${ARG_DEPENDS})
    
    set_target_properties(${ARG_NAME}Shared PROPERTIES OUTPUT_NAME ${ARG_NAME})
    set_target_properties(${ARG_NAME}Shared PROPERTIES VERSION ${ARG_VERSION})
    set_target_properties(${ARG_NAME}Shared PROPERTIES SOVERSION ${ARG_VERSION})

    install(TARGETS ${ARG_NAME}Shared 
            DESTINATION ${ARG_INSTALL_DESTINATION} 
            EXPORT ${ARG_NAME}Targets)
  endif()
endfunction()
