#!/bin/bash

#### for reference, below block from 3dvar test driver with test call for diffusion BEC generation included;

# Set the queueing options  (double hash to actually comment out instead of acting as slurm directives)
##SBATCH --nodes=12 --ntasks-per-node=10 --exclusive
##SBATCH -t 0:15:00
##SBATCH -A zrtrr 
##SBATCH --partition=xjet,kjet
##SBATCH -q debug ##urgent #batch ##debug
##SBATCH -J fv3jedi_bec 

#set -x

#module purge
#module use /lfs5/BMC/wrfruc/bjallen/JEDI-AOD/RDASApp/modulefiles
#module load RDAS/jet.intel


#export OOPS_TRACE=1
#export OOPS_DEBUG=1
#export MAIN_TRACE=1
#export MAIN_DEBUG=1

#3Dvar
#mkdir -p Data/analysis
#mkdir -p Data/hofx
#srun -n 120 fv3jedi_var.x 3dvar_rrfssd_aodda_smoke_diffusion_j01_iodathin.yaml

#### end test driver block

. ${GLOBAL_VAR_DEFNS_FP}
. $USHdir/source_util_funcs.sh

source ${MODULE_FILE}


# don't do JEDI AOD on cold start
hour=${ANL_TIME:8:2}
if [[ ${hour} -eq "03" ]] || [[ ${hour} -eq "15" ]]; then
  if [ ${FV3FCST_TYPE} == "spinup" ]; then
    exit 0
  fi
fi

# don't JEDI AOD if no IODA file exists for the hour leading up to the current analysis time
echo ${VIIRS_AOD_OBS_FN}
if [[ ! -e ${VIIRS_AOD_OBS_FN} ]]; then
   echo "No AOD IODA file exists for this time minus one hour"
   exit 0
fi

if [ ! -d ${WORK_DIR} ]; then
   mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}
# clean up
unlink INPUT
rm logfile.000000.out

FV3NAMELIST=${WORK_DIR}/GSL_fv3input_for_aod.nml
sed "s/LX,LY/${LX},${LY}/1" < ${FIX_JEDIAOD}/${NML_TMP} > ${FV3NAMELIST}


if [[ ${FV3FCST_TYPE} == "spinup" ]]; then
  task_name_det="fcst_fv3lam_spinup"
else
  task_name_det="fcst_fv3lam"
fi


#task_name_ens="fcst_fv3lam_spinup"
task_name_ens="fcst_fv3lam"

echo "bkg_root: ${BKG_ROOT}"
BKG_DIR=${BKG_ROOT}/${task_name_det}/INPUT

if [ ! -d ${WORK_DIR}/LOG ]; then
   mkdir -p ${WORK_DIR}/LOG
fi

#not entirely sure this matters?
#ln -sf ${FIX_JEDIAOD} ./INPUT  # link grid info to work_dir
ln -sf ${BKG_DIR} ./INPUT

#apparently also need to link to 3dvar_c84 Data directory (also contains grid info)
ln -sf /lfs5/BMC/wrfruc/bjallen/JEDI-AOD/3dvar_c84/Data ./Data

set -x
# Setup YAML file variables
WINDOW_TIME_STR=`date -d "${ANL_TIME::8} ${ANL_TIME:8:4} -1 hour" +%Y-%m-%dT%H:%M:00Z`
ANL_TIME_STR=`date -d "${ANL_TIME::8} ${ANL_TIME:8:4}" +%Y-%m-%dT%H:%M:00Z`
YYYYMMDD_HHMM=`date -d "${ANL_TIME::8} ${ANL_TIME:8:4}" +%Y%m%d.%H%M`

sed "s/WINDOW_TIME/${WINDOW_TIME_STR}/g" < ${FIX_JEDIAOD}/fv3jedi_3dvar_aod_smoke.yaml_template | \
   sed "s+EXPT_ROOT+${FIX_JEDIAOD}+g" | \
   sed "s+FV3NAMELIST+${FV3NAMELIST}+g" | \
   sed "s/ANALYSIS_TIME/${ANL_TIME_STR}/g" | \
   sed "s+BKG_DIR+${BKG_DIR}+g" | \
   sed "s/YYYYMMDD.HHMMSS/${YYYYMMDD_HHMM}00/g" | \
   sed "s/FV3FCST_TYPE/${task_name_det}/g" | \
   sed "s+FV3JEDI_DIAG_FN+${WORK_DIR}/${FV3JEDI_DIAG_FN}+g" | \
   sed "s+AOD_OBS_FN+${VIIRS_AOD_OBS_FN}+g" | \
   sed "s+OUT_DIR+${WORK_DIR}+g" | \
   sed "s/DESC/${FV3JEDI_AOD_DESC}/g" > ${WORK_DIR}/fv3jedi_3dvar_aod_smoke.yaml

cat ${WORK_DIR}/fv3jedi_3dvar_aod_smoke.yaml
srun --export=ALL ${FV3JEDI_BINDIR}/fv3jedi_var.x fv3jedi_3dvar_aod_smoke.yaml ${WORK_DIR}/LOG/LOG_VAR_AOD_SMOKE
