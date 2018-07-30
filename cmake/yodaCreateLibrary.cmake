##===-------------------------------------------------------------------------------------------===##
##                        _..._                                                          
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(yodaIncludeGuard)
yoda_include_guard()

include(CMakeParseArguments)

#.rst:
# .. _yoda_create_library:
#
# yoda_create_library
# -------------------------
#
# Create an object library with target *<TARGET>Objects* and combine the Objects library with the dependencies 
# in a static (and optionally) shared library with names *<TARGET>Objects.a* , *<NAME>Static.a* and 
# *<NAME>Shared.so* respectively. The shared library is compiled if the global CMake variable ``BUILD_SHARED_LIBS``
# is active
# 
# .. code-block:: cmake 
#
#   yoda_create_library(TARGET SOURCES VERSION TARGET_GROUP TARGET_NAMESPACE 
#           INSTALL_DESTINATION OBJECTS LIBRARIES DEPENDS SOURCES PUBLIC_BUILD_INCLUDES 
#           PUBLIC_INSTALL_INCLUDES INTERFACE_BUILD_INCLUDES INTERFACE_INSTALL_INCLUDES 
#           PRIVATE_BUILD_INCLUDES )
#
# ``TARGET:STRING``
#    Target name of the library
# ``SOURCES:STRING=<>``
#    List of source files to be comiled in the library
# ``VERSION:STRING``
#    version of the library
# ``TARGET_GROUP:STRING`` [optional]
#    Target group where the target will be added. The target will be exported in file
#    <INSTALL_DESTINATION>/<TARGET_GROUP>.cmake
# ``TARGET_NAMESPACE:STRING`` [optional]
#    Namespace where the target will be generated
# ``INSTALL_DESTINATION:STRING`` [optional]
#    path to install directory
# ``OBJECTS:STRING=<>`` [optional]
#    Object libraries to include in the library
# ``LIBRARIES:STRING=<>`` [optional]
#    External libraries (not CMake targets) on which the library depends on
# ``DEPENDS:STRING=<>`` [optional]
#    CMake target libraries on which the library depends on
# ``[PUBLIC|INTERFACE|PRIVATE]_[BUILD|INSTALL]_INCLUDES`` [optional]
#    List of include paths to add as property of the target. Different argument keywords are used to 
#    specify PUBLIC, INTERFACE or PRIVATE properties as well as to add it to the BUILD or INSTALL 
#    generator expression
function(yoda_create_library)

  #
  # Parse arguments
  #
  set(options NATIVE_PYTHON_LIB)
  set(oneValueArgs TARGET TARGET_GROUP INSTALL_DESTINATION TARGET_NAMESPACE)
  set(multiValueArgs OBJECTS LIBRARIES DEPENDS SOURCES PUBLIC_BUILD_INCLUDES PUBLIC_INSTALL_INCLUDES 
            INTERFACE_BUILD_INCLUDES INTERFACE_INSTALL_INCLUDES PRIVATE_BUILD_INCLUDES VERSION)
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
    set(__include_paths PUBLIC)
    foreach(inc_dir ${publicBuildIncludes})
      if(${inc_dir} STREQUAL "SYSTEM")
        set(__include_paths SYSTEM PUBLIC) 
        continue()
      else()
        list(APPEND __include_paths $<BUILD_INTERFACE:${inc_dir}>)
        target_include_directories(${target}Objects ${__include_paths})
        set(__include_paths PUBLIC)
      endif()
    endforeach()
    foreach(inc_dir ${publicInstallIncludes})
      set(__include_paths PUBLIC)
      if(${inc_dir} STREQUAL "SYSTEM")
        message(FATAL "SYSTEM keyword is not allowed in the PUBLIC_INSTALL_XXX")
      else()
        list(APPEND __include_paths $<INSTALL_INTERFACE:${inc_dir}>)
        target_include_directories(${target}Objects ${__include_paths})
      endif()
    endforeach()

    unset(__include_paths)
  endif()

  if(NOT("${privateBuildIncludes}" STREQUAL ""))
    target_include_directories(${target}Objects PRIVATE ${privateBuildIncludes} )
  endif()

  ## Propagate the interface include directories of dependencies
  unset(__include_paths)
  foreach(lib ${depends})
    list(APPEND __include_paths $<BUILD_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>)
    list(APPEND __include_paths $<INSTALL_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>)
  endforeach()

  target_include_directories(${target}Objects PUBLIC ${__include_paths} )
  unset(__include_paths)

  set(opt_arg)
  if(ARG_TARGET_GROUP) 
    set(opt_arg ${opt_arg} TARGET_GROUP ${ARG_TARGET_GROUP})
  endif()
  if(ARG_TARGET_NAMESPACE)
    set(opt_arg ${opt_arg} TARGET_NAMESPACE ${ARG_TARGET_NAMESPACE})
  endif()

  yoda_combine_libraries(
    NAME ${target}
    OBJECTS ${target}Objects ${objects}
    INSTALL_DESTINATION ${install_destination} 
    VERSION ${version}
    DEPENDS ${libraries} ${depends}
    ${opt_arg}
  )

  set(target_libs ${target}Static)
  if(BUILD_SHARED_LIBS) 
    set(target_libs ${target_libs} ${target}Shared)
  endif(BUILD_SHARED_LIBS)


  ## For the libraries built from the Objects file, we dont need to declare the public include directories,
  ## since the object files are already compiled, but we need to propate the include directories as interface
  foreach(target_lib ${target_libs})

    if(NOT("${publicBuildIncludes}" STREQUAL "") OR NOT("${publicInstallIncludes}" STREQUAL ""))
      set(__include_paths INTERFACE)
      foreach(inc_dir ${publicBuildIncludes})
        if(${inc_dir} STREQUAL "SYSTEM")
          set(__include_paths SYSTEM INTERFACE) 
          continue()
        else()
          list(APPEND __include_paths $<BUILD_INTERFACE:${inc_dir}>)
          target_include_directories(${target_lib} ${__include_paths})
          set(__include_paths INTERFACE)
        endif()
      endforeach()
      foreach(inc_dir ${publicInstallIncludes})
        set(__include_paths INTERFACE)
        if(${inc_dir} STREQUAL "SYSTEM")
          message(FATAL "SYSTEM keyword is not allowed in the PUBLIC_INSTALL_XXX")
        else()
          list(APPEND __include_paths $<INSTALL_INTERFACE:${inc_dir}>)
          target_include_directories(${target_lib} ${__include_paths})
        endif()
      endforeach()

      unset(__include_paths)
    endif()

    if(NOT("${interfaceBuildIncludes}" STREQUAL "") OR NOT("${interfaceInstallIncludes}" STREQUAL ""))
      set(__include_paths INTERFACE)
      if(NOT("${interfaceBuildIncludes}" STREQUAL ""))
        list(APPEND __include_paths $<BUILD_INTERFACE:${interfaceBuildIncludes}>)
      endif()
      if(NOT("${interfaceInstallIncludes}" STREQUAL ""))
        list(APPEND __include_paths $<INSTALL_INTERFACE:${interfaceInstallIncludes}>)
      endif()
      target_include_directories(${target_lib} ${__include_paths} )
      unset(__include_paths)
    endif()
  endforeach()

## Propagate the interface include directories of dependencies
  unset(__include_paths)
  foreach(lib ${depends})
    list(APPEND __include_paths $<BUILD_INTERFACE:$<TARGET_PROPERTY:${lib},INTERFACE_INCLUDE_DIRECTORIES>>)
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

