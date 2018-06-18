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

include(mchbuildCheckAndSetCXXFlag)

#.rst:
# mchbuild_set_cxx_standard
# ------------------------------------
#
# Set the minimum standard of C++.
#
# .. code-block:: cmake
#
#   mchbuild_set_cxx_standard(MIN_CXX_STANDARD)
#
# ``MIN_CXX_STANDARD``
#   Minimum C++ standard which needs to be supported, one of 
#   [``c++11``, ``c++14``, ``c++1z``, ``c++17``, ``c++2a``].
#
macro(mchbuild_set_cxx_standard MIN_CXX_STANDARD)
  set(supported_standards "c++11" "c++14" "c++1z" "c++17" "c++2a")    
  
  if(NOT("${MIN_CXX_STANDARD}" IN_LIST supported_standards))
    message(FATAL_ERROR 
            "Unknown C++ standard (${MIN_CXX_STANDARD}), supported values: ${supported_standards}")
  endif()
  
  set(std_cxx ${MIN_CXX_STANDARD})
    
  if(WIN32 AND NOT MINGW)
    set(cxx_flag "/std:${std_cxx}")
  elseif(CYGWIN)
    string(REPLACE "c" "gnu" ${std_cxx} gnu_standard)
    set(cxx_flag "-std=${gnu_standard}")
  else()
    set(cxx_flag "-std=${std_cxx}")
  endif()
    
  string(TOUPPER ${std_cxx} STD_CXX)
  string(REPLACE "+" "X" STD_CXX ${STD_CXX})
  mchbuild_check_and_set_cxx_flag("${cxx_flag}" HAVE_${STD_CXX}_STANDARD_SUPPORT)
  
  if(NOT(HAVE_${STD_CXX}_STANDARD_SUPPORT))
    message(FATAL_ERROR "The compiler ${CMAKE_CXX_COMPILER} has no ${MIN_CXX_STANDARD} support.")
  endif()
endmacro()
