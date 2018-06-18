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

include(mchbuildCheckInSourceBuild)
include(mchbuildGetArchitectureInfo)
include(mchbuildGetCompilerInfo)
include(mchbuildGetPlatformInfo)
include(mchbuildMakeStringPair)
include(mchbuildReportResult)

#we add the modules directory of mchbuild
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/modules")

#.rst:
# mchbuild_init
# ----------------
#
# Function to initialize mchbuild infrastructure
#
# .. code-block:: cmake
#
#   mchbuild_init()
#
function(mchbuild_init)

  mchbuild_get_compiler_info()
  mchbuild_get_platform_info()
  mchbuild_get_architecture_info()

  # Prevent in source builds
  mchbuild_check_in_source_build()
  
  # Output summary of the configuration
  macro(make_config_string FIRST SECOND)
    mchbuild_make_string_pair(${FIRST} ": ${SECOND}" 20 out)
    list(APPEND config_info ${out})
  endmacro()
  make_config_string("Platform" ${MCHBUILD_PLATFORM_STRING})
  make_config_string("Architecture" ${MCHBUILD_ARCHITECTURE_STRING})
  make_config_string("Compiler" ${MCHBUILD_COMPILER_STRING})
  make_config_string("Build type" ${CMAKE_BUILD_TYPE})
  mchbuild_report_result("Configuration summary" ${config_info})

endfunction()

