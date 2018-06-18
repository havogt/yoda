##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

include(ExternalProject)
include(yodaSetExternalProperties)
include(yodaRequireArg)

set(DIR_OF_BOOST_EXTERNAL ${CMAKE_CURRENT_LIST_DIR})

function(yoda_external_package)
  set(options)
  set(one_value_args URL URL_MD5 DOWNLOAD_DIR)
  set(multi_value_args REQUIRED_VARS CMAKE_ARGS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  yoda_require_arg("URL" ${ARG_URL})
  yoda_require_arg("DOWNLOAD_DIR" ${ARG_DOWNLOAD_DIR})
  yoda_require_arg("URL_MD5" ${ARG_URL_MD5})

  if(NOT("${ARG_UNPARSED_ARGUMENTS}" STREQUAL ""))
    message(FATAL_ERROR "invalid argument ${ARG_UNPARSED_ARGUMENTS}")
  endif()


  if("${CMAKE_CURRENT_BINARY_DIR}" MATCHES " ")
    message(FATAL_ERROR "cannot use boost-bootstrap with a space in the name of the build diretory")
  endif()

  # Build system library which disables all other libraries
  set(boost_args "--with-system")

  if(BUILD_SHARED_LIBS)
    list(APPEND boost_args "link=shared")
  else()
    list(APPEND boost_args "link=static")
  endif()

  yoda_set_external_properties(NAME "boost" 
      INSTALL_DIR install_dir 
      SOURCE_DIR source_dir)

  ExternalProject_Add(boost
    DOWNLOAD_DIR ${ARG_DOWNLOAD_DIR}
    URL ${ARG_URL}
    URL_MD5 ${ARG_MD5}
    SOURCE_DIR "${source_dir}"
    INSTALL_DIR "${install_dir}"
    CONFIGURE_COMMAND ./bootstrap.sh --prefix=<INSTALL_DIR>
    BUILD_COMMAND ./b2 --prefix=<INSTALL_DIR> address-model=64 ${boost_args}
    INSTALL_COMMAND ./b2 --prefix=<INSTALL_DIR> address-model=64 ${boost_args} install
    BUILD_IN_SOURCE 1
  )

  ExternalProject_Get_Property(boost install_dir)
  set(BOOST_ROOT "${install_dir}" CACHE INTERNAL "")
  set(Boost_INCLUDE_DIR ${BOOST_ROOT}/include)

endfunction()
