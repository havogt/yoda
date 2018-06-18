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
# mchbuild_get_platform_info
# -------------------------------------
#
# Get the identification string of the platform.
#
# .. code-block:: cmake
#
#   mchbuild_get_platform_info()
#
# The functions defines the following variable:
#
# ``MCHBUILD_PLATFORM_STRING``
#   String of the platform.
#
# and conditionally the following:
#
# ``MCHBUILD_ON_WIN32``
#   Set to 1 if the platform is Win32-ish
# ``MCHBUILD_ON_UNIX``
#   Set to 1 if the platform is Unix-ish
# ``MCHBUILD_ON_APPLE``
#   Set to 1 if the platform is Darwin
# ``MCHBUILD_ON_LINUX``
#   Set to 1 if the platform is Linux
#
macro(mchbuild_get_platform_info)
  if(WIN32)
    set(MCHBUILD_ON_WIN32 1 CACHE INTERNAL "Platform is Win32-ish" FORCE)
    set(MCHBUILD_PLATFORM_STRING "Windows" CACHE INTERNAL "Platform-id string" FORCE)
  elseif(APPLE)
    set(MCHBUILD_ON_UNIX 1 CACHE INTERNAL "Platform is Unix-ish" FORCE)
    set(MCHBUILD_ON_APPLE 1 CACHE INTERNAL "Platform is Darwin" FORCE)
    set(MCHBUILD_PLATFORM_STRING "Darwin" CACHE INTERNAL "Platform-id string" FORCE)
  elseif(UNIX)
    set(MCHBUILD_ON_UNIX 1 CACHE INTERNAL "Platform is Unix-ish" FORCE)
    set(MCHBUILD_ON_LINUX 1 CACHE INTERNAL "Platform is Linux" FORCE)
    set(MCHBUILD_PLATFORM_STRING "Linux" CACHE INTERNAL "Platform-id string" FORCE)
  endif()
endmacro()
