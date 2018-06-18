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

function(mchbuild_require_only_one_of2)
  set(options)
  set(one_value_args NAME1 NAME2)
  set(multi_value_args GROUP1 GROUP2)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if((NOT ARG_GROUP1) AND (NOT ARG_GROUP2))
    message(FATAL_ERROR "Need to specify at least parameters of one of the two groups: ${ARG_NAME1} or ${ARG_NAME2}: ${ARG_GROUP1} ; ${ARG_GROUP2}")
  endif()
  if( (ARG_GROUP1) AND (ARG_GROUP2))
    message(FATAL_ERROR "You can not specify simultaneously properties of the two groups: ${ARG_NAME1} or ${ARG_NAME2}: ${ARG_GROUP1} ; ${ARG_GROUP2}")
  endif()

endfunction()

function(mchbuild_require_only_one_of3)
  set(options)
  set(one_value_args NAME1 NAME2 NAME3)
  set(multi_value_args GROUP1 GROUP2 GROUP3)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if((NOT ARG_GROUP1) AND (NOT ARG_GROUP2) AND(NOT ARG_GROUP3))
    message(FATAL_ERROR "Need to specify at least parameters of one of the two groups: ${ARG_NAME1} or ${ARG_NAME2}")
  endif()
  set(CNT 1)

  if(ARG_GROUP1)
    MATH(EXPR CNT "${CNT}+1")
  endif()
  if(ARG_GROUP2)
    MATH(EXPR CNT "${CNT}+1")
  endif()
  if(ARG_GROUP2)
    MATH(EXPR CNT "${CNT}+1")
  endif()

  if(CNT GREATER 1)
    message(FATAL_ERROR "You can not specify simultaneously properties of the two groups: ${ARG_NAME1}, ${ARG_NAME2} or ${ARG_NAME3}: ${ARG_GROUP1} ; ${ARG_GROUP2} ; ${ARG_GROUP3}")
  endif()

endfunction()
