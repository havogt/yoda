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

#.rst:
# msbuid_get_compiler_info
# ------------------------
#
# Get the identification string of the compiler.
#
# .. code-block:: cmake
#
#   mchbuild_get_compiler()
#
# The functions defines the following variable:
#
# ``MCHBUILD_COMPILER_STRING``
#   String of the currently used compiler.
# 
# and conditionally one of the following:
#
# ``MCHBUILD_COMPILER_MSVC``
#   Set to 1 if the compiler in use is MSVC
# ``MCHBUILD_COMPILER_GNU``
#   Set to 1 if the compiler in use is GNU
# ``MCHBUILD_COMPILER_CLANG``
#   Set to 1 if the compiler in use is Clang
#
macro(mchbuild_get_compiler_info)
  if("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    set(MCHBUILD_COMPILER_MSVC 1 CACHE INTERNAL "Compiler is MSVC" FORCE)
    set(MCHBUILD_COMPILER_STRING "Visual Studio (${CMAKE_CXX_COMPILER_VERSION})" 
        CACHE INTERNAL "Compiler-id string" FORCE)
  elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
    set(MCHBUILD_COMPILER_GNU 1 CACHE INTERNAL "Compiler is GNU gcc" FORCE)
    set(MCHBUILD_COMPILER_STRING "GNU gcc (${CMAKE_CXX_COMPILER_VERSION})" 
        CACHE INTERNAL "Compiler-id string" FORCE)
  elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    set(MCHBUILD_COMPILER_CLANG 1 CACHE INTERNAL "Compiler is LLVM Clang" FORCE)
    set(MCHBUILD_COMPILER_STRING "LLVM Clang (${CMAKE_CXX_COMPILER_VERSION})" 
        CACHE INTERNAL "Compiler-id string" FORCE)
  endif()
endmacro()
