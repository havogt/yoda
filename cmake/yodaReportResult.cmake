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
# mchbuild_report_result
# ---------------------------------
#
# Report a list of strings, encompassed by a box.
#
# .. code-block:: cmake
#
#   mchbuild_report_result(HEADER [ARGN...])
#
# ``HEADER``
#   Header to print
# ``ARGN``
#   List of strings to report
#
function(mchbuild_report_result HEADER)
  string(LENGTH ${HEADER} header_length)
  set(full_header "----------------------------------------------------------------")
  math(EXPR right_header_length "43 - ${header_length}")
  string(SUBSTRING ${full_header} "0" "${right_header_length}" right_header)
  
  message(STATUS "------------------- ${HEADER} ${right_header}")
  foreach(arg ${ARGN})
    message(STATUS "${arg}")
  endforeach()
  message(STATUS "${full_header}")
endfunction()
