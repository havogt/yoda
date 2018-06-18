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

get_filename_component(__mchbuild_cmake_script_dir__ ${CMAKE_CURRENT_LIST_FILE} PATH)

#.rst:
# mchbuild_get_script_dir
# ------------------------
#
# Get the directory of the scripts located ``<mchbuild-root>/cmake/scripts``.
#
# .. code-block:: cmake
#
#   mchbuild_get_script_dir(SCRIPT_DIR_VAR)
# 
# * Output arguments:
#
# ``SCRIPT_DIR_VAR``
#   Variable which will contain the script directory on output.
#
# .. note:: This function is for internal use only.
#
function(mchbuild_get_script_dir SCRIPT_DIR_VAR)
  set(${SCRIPT_DIR_VAR} "${__mchbuild_cmake_script_dir__}/scripts" PARENT_SCOPE)
endfunction()
