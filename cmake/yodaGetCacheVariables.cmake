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
# mchbuild_get_cache_variables
# ----------------------------
#
# It returns, in the output variable, the list of cmake args used to 
# call cmake from command line
#
# .. code-block:: cmake
#
#   mchbuild_get_cache_variables(CMAKE_ARGS)
# 
# * Output arguments:
#
# ``CMAKE_ARGS:LIST``
#   Variable which will contain the list of cmake arguments
#
function(mchbuild_get_cache_variables CMAKE_ARGS_)
  get_cmake_property(CACHE_VARS CACHE_VARIABLES)

  set(CMAKE_ARGS "")
  foreach(CACHE_VAR ${CACHE_VARS})
    get_property(CACHE_VAR_HELPSTRING CACHE ${CACHE_VAR} PROPERTY HELPSTRING)
    if(CACHE_VAR_HELPSTRING STREQUAL "No help, variable specified on the command line.")
      get_property(CACHE_VAR_TYPE CACHE ${CACHE_VAR} PROPERTY TYPE)
      if(CACHE_VAR_TYPE STREQUAL "UNINITIALIZED")
        set(CACHE_VAR_TYPE)
      else()
        set(CACHE_VAR_TYPE :${CACHE_VAR_TYPE})
      endif()
      list(APPEND CMAKE_ARGS "-D${CACHE_VAR}${CACHE_VAR_TYPE}=${${CACHE_VAR}}")
    endif()
  endforeach()
  set(${CMAKE_ARGS_} ${CMAKE_ARGS} PARENT_SCOPE)
endfunction()
