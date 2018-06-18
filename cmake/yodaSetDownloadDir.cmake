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

#.rst:
# mchbuild_set_download_dir
# ----------------------------
#
# This script defines a MCHBUILD_DOWNLOAD_DIR variable, if it's not already defined.
#
# Cache the downloads in MCHBUILD_DOWNLOAD_DIR if it's defined. Otherwise, use the user's typical 
# Downloads directory, if it already exists. Otherwise, use a Downloads subdir in the build tree.
#
macro(mchbuild_set_download_dir)
  if(NOT DEFINED MCHBUILD_DOWNLOAD_DIR)
    if(NOT "$ENV{HOME}" STREQUAL "" AND EXISTS "$ENV{HOME}/Downloads")
      set(MCHBUILD_DOWNLOAD_DIR "$ENV{HOME}/Downloads")
    elseif(NOT "$ENV{USERPROFILE}" STREQUAL "" AND EXISTS "$ENV{USERPROFILE}/Downloads")
      set(MCHBUILD_DOWNLOAD_DIR "$ENV{USERPROFILE}/Downloads")
    elseif(NOT "${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "")
      set(MCHBUILD_DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/Downloads")
    else()
      message(FATAL_ERROR "unexpectedly empty CMAKE_CURRENT_BINARY_DIR")
    endif()
    string(REPLACE "\\" "/" MCHBUILD_DOWNLOAD_DIR "${MCHBUILD_DOWNLOAD_DIR}")
  endif()

  file(MAKE_DIRECTORY "${MCHBUILD_DOWNLOAD_DIR}")
  if(NOT EXISTS "${MCHBUILD_DOWNLOAD_DIR}")
    message(FATAL_ERROR "could not find or make download directory")
  endif()
endmacro()
