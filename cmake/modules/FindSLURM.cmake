##===-------------------------------------------------------------------------------------------===##
##
##  This file is distributed under the MIT License (MIT). 
##  See LICENSE.txt for details.
##
##===------------------------------------------------------------------------------------------===##

#.rst:
# .. _FindSLURM:
#
# FindSLURM
# --------
#
# .. code-block:: cmake
#
#   find_package(SLURM [REQUIRED] [QUIET])
#
# Find the SLURM executables and variables.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# Defines the following variables:
#
# ``SLURM_SBATCH_COMMAND``
#   the path to sbatch command
# ``SLURM_SRUN_COMMAND``
#   the path to srun submission command
# ``SLURM_SACCTMGR_COMMAND``
#   the path to sacctmgr command
#

find_program(SLURM_SBATCH_COMMAND sbatch DOC "Path to the SLURM sbatch executable")
find_program(SLURM_SRUN_COMMAND srun DOC "Path to the SLURM srun executable")
find_program(SLURM_SACCTMGR_COMMAND sacctmgr DOC "Path to the SLURM sacctmgr executable")
mark_as_advanced(SLURM_SRUN_COMMAND SLURM_SBATCH_COMMAND SLURM_SACCTMGR_COMMAND)

if(SLURM_SRUN_COMMAND AND SLURM_SBATCH_COMMAND)
  set(SLURM_FOUND true)
  if(NOT SLURM_FIND_QUIETLY)
    message (STATUS "Found SLURM. SLURM_SBATCH_COMMAND: ${SLURM_SBATCH_COMMAND}, SLURM_SRUN_COMMAND: ${SLURM_SRUN_COMMAND}, SLURM_SACCTMGR_COMMAND: ${SLURM_SACCTMGR_COMMAND}")
  endif()
else()
  set(SLURM_FOUND false )
  if(SLURM_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find SLURM")
  elseif(NOT SLURM_FIND_QUIETLY)
    message(STATUS "Could not find SLURM")
  endif()
endif()
