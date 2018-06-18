User Manual
===================

yoda is a cmake based library that provides ways to describe the dependencies of a project 
and resolves and builds all the depencies with a single cmake configuration  and build step.
yoda provides a set of cmake macros and functions and requires the use of a convention on 
how to write cmake project for all the projects in the dependency chain (except for the external 
dependencies). 

We will use the following figure to show how to build the dependency chain shown in the picture: 

.. figure:: figures/pack_dep.png
  
  Example of dependency chain of packages.  

In the example we assume ``packA``, ``packB``, ``packC`` are software packages of our organization
where we will directly use yoda from the cmake configuration of the projects, while
``packExt1`` and ``packExt2`` are external packages where we can not modify the configuration & installation
infrastructure, and possibly could not make use of cmake.

Basic CMakeLists.txt
------------------------

It is assumed that each project (``packA``, ``packB``, ``packC``) will contain a cmake project, with a CMakeLists.txt
on the root directory of the project.

Like that, configuring ``packA`` using will require passing the dependent installation via cmake command line

.. code-block:: bash

  mkdir build; cd build
  cmake .. -DPACKB_ROOT=<packb_dir> -DPACKC_ROOT=<packc_dir>


Setup a cmake bundle
----------------------

Using yoda will require creating an additional cmake project file, called a bundle, inside each project. 
The bundle file
will define all the dependent packages one by one, and at the end of the bundle, it will add the root CMakeLists.txt
of the project as yet another external project of the bundle. All the dependent project
(except the external dependencies) will require as well a bundle cmake file. 


The configuration of the bundle will be placed in
``<project>/bundle/CMakeLists.txt``

The bundle file should contain the following cmake blocks:

* Locally clone the yoda package. In order to do that there is a cmake macro in 
  yoda that helps cloning git repositories. Copy manually the macro ``yodaCloneRepository``
  (from the yoda repository) into the current package and use it from the bundle CMakeLists.txt 
  to clone yoda

.. code-block:: cmake

  include(yodaCloneRepository)

  set(PACKA_YODA_GIT_URL "https:///github.com/Meteoswiss-APN/yoda.git" CACHE PATH "")
  set(PACKA_YODA_GIT_BRANCH "master" CACHE STRING "")
  yoda_clone_repository(NAME yoda URL ${PACKA_YODA_GIT_URL} BRANCH ${PACKA_YODA_GIT_BRANCH} SOURCE_DIR PACKA_YODA_SOURCE_DIR )

* We can add dependencies (other yoda projects) using the yoda_find_package:

  .. code-block:: cmake

    yoda_find_package(
      PACKAGE packB
      REQUIRED_VAR packB_DIR
      DEPENDS "packext1" "packext2"
      ADDITIONAL
        GIT_REPOSITORY "https://github.com/Meteoswiss-APN/packB.git"
        GIT_TAG "develop" 
        YODA_ROOT "${PACKA_YODA_SOURCE_DIR}"
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> ...
    )
  
  Notice that yoda will require that the dependent package ``packB`` contains a bundle cmake project, 
  but not for the external dependencies ``packExt1`` and ``packExt2``.
  The ``REQUIRED_VAR`` will require the external project finder to set properly the ``packB_DIR`` variable, pointing to 
  the external project directory that contains the corresponding cmake Config file. 

* We can also add external dependencies using the yoda_find_package. See for example how to add dependency on ``packExt1``

  .. code-block:: cmake

    yoda_find_package(
      PACKAGE packExt1
      COMPONENTS "comp1" "comp2"
      REQUIRED_VARS PACKEXT1_ROOT
      ADDITIONAL
        DOWNLOAD_DIR ${YODA_DOWNLOAD_DIR}
        URL "http://sourceforge.net/projects/packExt1"
        URL_MD5 "7b493c08bc9557bbde7e29091f28b605" 
        BUILD_VERSION 1.58.0
    )

* Add the package itself, i.e. the root CMakeLists.txt (from the CMakeLists.txt in the bundle directory) as another external dependency

  .. code-block:: cmake

    yoda_find_package(
      PACKAGE packA
      FORWARD_VARS 
        BINARY_DIR packA_binary_dir
      DEPENDS "packa" "packc"
      ADDITIONAL
        SOURCE_DIR "${CMAKE_SOURCE_DIR}/../"
        YODA_ROOT "${GTCLANG_YODA_SOURCE_DIR}"
        CMAKE_ARGS -DpackB_DIR=${packB_DIR}
    )
 
  Since we are adding the root CMakeLists.txt of this project, packA, as a cmake external package, 
  instead of specifying a GIT url, here we simply specify the source directory that contains the root CMakeLists.txt
 
  Notice that here we use the cmake config directories obtained by previous calls to ``yoda_find_package`` 
  to set the cmake paths in  ``CMAKE_ARGS``

* The root CMakeLists.txt will contain some tests, but the bundle cmake project still does not contain any test. 
  Therefore, at the end of the bundle we forward the tests defined in the root CMakeLists.txt of ``packA`` to the bundle
  project

  .. code-block:: cmake

     add_test(NAME packA-tests 
       COMMAND  ${CMAKE_COMMAND} --build ${packA_binary_dir} --target test
     )

  Notice we make use of the cmake binary directory of packA, since the test targets are defined in that build directory.  


The external project files
-----------------------------

Each cmake call to ``yoda_find_package`` will first try to find a cmake config file of the project, in the cmake search paths
(``CMAKE_MODULE_PATH```or user provided ``-Dpack_DIR=<>`` paths). 
If the package is not found, it will then try to clone or download the package and compile it before continue processing the rest of 
the bundle.
For each package that might be added as a dependency from a bundle, there should be a cmake file,
named following the convention ``External_<pack>.cmake``,
that contains the cmake functionality to download and compile the package. 

In the following we describe the main components of a ``External_<pack>.cmake``:

* First of all notice that each ``External_<pack>.cmake`` should define a target, used later in the bundle files to describe the 
  dependencies of each package. The convention is that the target is the name of the package all letter lower case.

* Get the source,build and install directories for the compilation of the dependent project using the following yoda macro

  .. code-block:: cmake

      yoda_set_external_properties(NAME "packa" 
        INSTALL_DIR install_dir 
        SOURCE_DIR source_dir
        BINARY_DIR binary_dir
      )

* Add an external project for the package. Since the bundle will add external projects passing a GIT url and it will add its own top project
  indicating the source directory, we need to possibly add the external project for these two cases:

  .. code-block:: cmake

    if(ARG_GIT_REPOSITORY)
      ExternalProject_Add(packa
        PREFIX packA-prefix
        GIT_REPOSITORY ${ARG_GIT_REPOSITORY}
        GIT_TAG ${ARG_GIT_TAG}
        SOURCE_SUBDIR "bundle"
        INSTALL_DIR "${install_dir}"
        CMAKE_ARGS ${ARG_CMAKE_ARGS}
      )
    else()
      ExternalProject_Add(packa
        SOURCE_DIR ${ARG_SOURCE_DIR}
        INSTALL_DIR "${install_dir}"
        CMAKE_ARGS ${ARG_CMAKE_ARGS} 
    )
    endif()

* Set accordingly all the ``REQUIRED_VARS`` and ``FORWARD_VARS`` passed to ``yoda_find_package``. For example

  .. code-block:: cmake

      set(packA_DIR "${binary_dir}/prefix/packA/cmake" CACHE INTERNAL "")

