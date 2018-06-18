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

# gtclang_all_add_optional_deps
# -----------------------------
#
# Convenience macro for adding dependencies optionally if not using system libraries. This function 
# takes a list of external projects targets ARGN, looks for a variable of the form 
# USE_SYSTEM_<ARG> for each ARG in ARGN, if this does not exist or is set to FALSE the supplied 
# taget name will be added to DEP_VAR as a dependency.
#
#    DEP_VAR:STRING=<>      - Output variable containing the resolved dependencies
#    ARGN                   - Dependencies to append
#
macro(mchbuild_add_optional_deps DEP_VAR)
  foreach(dep ${ARGN})
    string(TOUPPER "${dep}" dependency)
    if(NOT USE_SYSTEM_${dependency})
      list(APPEND ${DEP_VAR} ${dep})
    endif()
  endforeach()
endmacro()
