##===-------------------------------------------------------------------------------------------===##
##                        _..._                                                          
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(CMakeParseArguments)

## .rst:
##   yoda_create_library
## -----------------------
##
## Create an object library with target "<TARGET>Objects" and combine the Objects library with the dependencies 
## in a static (and optionally) shared library with names "<NAME>Static.a" and <NAME>Shared.so" respectively.
## 
## .. code-block::cmake 
##
##    ypda_create_library(TARGET OBJECTS LIBRARIES DEPENDS SOURCES PUBLIC_BUILD_INCLUDES PUBLIC_INSTALL_INCLUDES 
##                                    INTERFACE_BUILD_INCLUDES INTERFACE_INSTALL_INCLUDES PRIVATE_BUILD_INCLUDES
##                                    VERSION INSTALL_DESTINATION)
##    ``TARGET:STRING=<>``
##       Name of the library
##    TARGET:STRING=<>                   - Target used by CMake (e.g SerialboxCoreLibrary)
##    OBJECTS:STRING=<>                  - Object libraries to include (e.g SerialboxCoreLibraryObjects)
##    NATIVE_PYTHON_LIB:BOOL=<>          - Generate a library which can be nativly imported in Python3. This
##                                         means the library will have no prefix and the suffix is set to .so
##    LIBRARIES:STRING<>                 - Specify external libraries or flags to be use when linking the 
##                                         target
##    DEPENDS:STRING=<>                  - Specify other targets the library depends on
##    SOURCES:STRING=<>                  - List of source files
##    VERSION:STRING=<>                  - version number of the library
##    INSTALL_DESTINATION:STRING=<>      - install directory
function(yoda_create_library)

  #
  # Parse arguments
  #
  set(options NATIVE_PYTHON_LIB)
  set(oneValueArgs TARGET)
  set(multiValueArgs OBJECTS LIBRARIES DEPENDS SOURCES PUBLIC_BUILD_INCLUDES PUBLIC_INSTALL_INCLUDES 
            INTERFACE_BUILD_INCLUDES INTERFACE_INSTALL_INCLUDES PRIVATE_BUILD_INCLUDES VERSION INSTALL_DESTINATION)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  yoda_require_arg("TARGET" ${ARG_TARGET})
  yoda_require_arg("VERSION" ${ARG_VERSION})

  set(nativePythonLibrary ${ARG_NATIVE_PYTHON_LIB})
  set(target ${ARG_TARGET})
  set(objects ${ARG_OBJECTS})
  set(addSymlinksTo ${ARG_SYMLINKS})
  set(libraries ${ARG_LIBRARIES})
  set(sources ${ARG_SOURCES})
  set(publicBuildIncludes ${ARG_PUBLIC_BUILD_INCLUDES})
  set(publicInstallIncludes ${ARG_PUBLIC_INSTALL_INCLUDES})
  set(interfaceBuildIncludes ${ARG_INTERFACE_BUILD_INCLUDES})
  set(interfaceInstallIncludes ${ARG_INTERFACE_INSTALL_INCLUDES})
  set(privateBuildIncludes ${ARG_PRIVATE_BUILD_INCLUDES})
  set(depends ${ARG_DEPENDS})
  set(version ${ARG_VERSION})
  if(ARG_INSTALL_DESTINATION)
    set(install_destination ${ARG_INSTALL_DESTINATION)
  else()
    set(install_destination lib)
  endif()

  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  #
  # Add object library
  #
  yoda_add_library(
    NAME ${target}
    SOURCES ${SOURCES}
    OBJECT
  )

  if(SERIALBOX_VERBOSE_WARNINGS)
    set_target_properties(${target}Objects PROPERTIES COMPILE_FLAGS -Wall)
  endif(SERIALBOX_VERBOSE_WARNINGS)

  if(NOT("${objects}" STREQUAL ""))
    set(OBJECT_SOURCES)
    foreach(object ${objects})
      list(APPEND OBJECT_SOURCES $<TARGET_OBJECTS:${object}>)
    endforeach()
  endif()

  if(NOT("${publicBuildIncludes}" STREQUAL "") OR NOT("${publicInstallIncludes}" STREQUAL ""))
    set(__include_paths "PUBLIC")
    foreach(inc_dir ${publicBuildIncludes})
      if(${inc_dir} STREQUAL "SYSTEM")
        set(__include_paths ${__include_paths} " " "SYSTEM")
      else()
        set(__include_paths ${__include_paths} " " "$<BUILD_INTERFACE:${inc_dir}>")
      endif()
    endforeach()
    foreach(inc_dir ${publicInstallIncludes})
      if(${inc_dir} STREQUAL "SYSTEM")
        set(__include_paths ${__include_paths} " " "SYSTEM")
      else()
        set(__include_paths ${__include_paths} " " "$<INSTALL_INTERFACE:${inc_dir}>")
      endif()
    endforeach()

    target_include_directories(${target}Objects ${__include_paths} )
    unset(__include_paths)
  endif()

  if(NOT("${privateBuildIncludes}" STREQUAL ""))
    target_include_directories(${target}Objects PRIVATE ${privateBuildIncludes} )
  endif()

  ## Propagate the interface include directories of dependencies
  foreach(lib ${depends})
    set(__include_paths ${__include_paths} "$<BUILD_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>")
    set(__include_paths ${__include_paths} "$<INSTALL_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>")
  endforeach()

  target_include_directories(${target}Objects PUBLIC ${__include_paths} )
  unset(__include_paths)

  if(nativePythonLibrary)
    set_target_properties(${target}Static PROPERTIES PREFIX "")
    set_target_properties(${target}Static PROPERTIES SUFFIX ".so")
  endif()

  yoda_combine_libraries(
    NAME ${target}
    OBJECTS ${target}Objects ${objects}
    INSTALL_DESTINATION ${install_destination} 
    VERSION ${version}
    DEPENDS ${libraries} ${depends}
  )

  set(target_libs ${target}Static)
  if(BUILD_SHARED_LIBS) 
    set(target_libs ${target_libs} ${target}Shared)
  endif(BUILD_SHARED_LIBS)


  ## For the libraries built from the Objects file, we dont need to declare the public include directories,
  ## since the object files are already compiled, but we need to propate the include directories as interface
  foreach(target_lib ${target_libs})
    if(NOT("${publicBuildIncludes}" STREQUAL "") OR NOT("${publicInstallIncludes}" STREQUAL ""))
      set(__include_paths "INTERFACE")
      if(NOT("${publicBuildIncludes}" STREQUAL ""))
        set(__include_paths ${__include_paths} " " "$<BUILD_INTERFACE:${publicBuildIncludes}>")
      endif()
      if(NOT("${publicInstallIncludes}" STREQUAL ""))
        set(__include_paths ${__include_paths} " " "$<INSTALL_INTERFACE:${publicBuildIncludes}>")
        target_include_directories(${target_lib} ${__include_paths} )
      endif()
        target_include_directories(${target_lib} ${__include_paths} )
      unset(__include_paths)
    endif()

    if(NOT("${interfaceBuildIncludes}" STREQUAL "") OR NOT("${interfaceInstallIncludes}" STREQUAL ""))
      set(__include_paths "INTERFACE")
      if(NOT("${interfaceBuildIncludes}" STREQUAL ""))
        set(__include_paths ${__include_paths} " " "$<BUILD_INTERFACE:${interfaceBuildIncludes}>")
      endif()
      if(NOT("${interfaceInstallIncludes}" STREQUAL ""))
        set(__include_paths ${__include_paths} " " "$<INSTALL_INTERFACE:${interfaceBuildIncludes}>")
        target_include_directories(${target_lib} ${__include_paths} )
      endif()
        target_include_directories(${target_lib} ${__include_paths} )
      unset(__include_paths)
    endif()
  endforeach()

## Propagate the interface include directories of dependencies
  foreach(lib ${depends})
    set(__include_paths ${__include_paths} "$<BUILD_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>")
    unset(__include_paths)
  endforeach()

  target_include_directories(${target}Static INTERFACE ${__include_paths} )
  unset(__include_paths)

##TODO propagate also includes for Build Lib

  if(nativePythonLibrary AND BUILD_SHARED_LIBS)
    set_target_properties(${target}Shared PROPERTIES PREFIX "")
    set_target_properties(${target}Shared PROPERTIES SUFFIX ".so")
  endif()
endfunction(yoda_create_library)

