#!/bin/bash

#There is also an exrrfs script like this one. Should this be a JRRFS or exrrfs script?

#dynamics updates are commented out but not deleted below. Later on, especially upon adding ensemble DA,
#more than just aerosol fields may need updated (nevermind, I'll include some of the dynamics updates).

#Question: What about updates from other tasks, like conventional DA w/ GSI and the cloud analysis? 
#Won't using the M1H (prior cycle) data below keep those updates from being included?

#Perhaps I'll need to copy over every updated variabe from both the dynamics and physics files.
#Was that what was being done for dbz and lightning DA?

. ${GLOBAL_VAR_DEFNS_FP}
. $USHdir/source_util_funcs.sh

module load nco

#below may not be needed for AOD, and doesn't quite work right for FED, either
#we'll see if there is an error without it.
#source $USHdir/run_convert_UV.sh

#hack to keep JEDI-IC task from overwriting things while testing hofx and envar tasks
#echo 'Exiting after convert_UV.sh with nonzero error code to halt workflow during testing'
#echo 'Remove or comment out these lines near top of modify_ICs.sh to run normally'
#exit 1

# don't use JEDI AOD DA at cold start hour 
#(guessing this is needed because the data files are different before the first forecast integration?)
hour=${ATIME:8:2}
if [[ ${hour} -eq "03" ]] || [[ ${hour} -eq "15" ]]; then
  if [ ${CYCLE_TYPE} == "spinup" ]; then
    exit 0
  fi
fi

# don't JEDI AOD if no IODA file exists for the hour leading up to current analysis time
echo ${VIIRS_AOD_OBS_FN}
if [[ ! -e ${VIIRS_AOD_OBS_FN} ]]; then
   echo "No AOD IODA file exists for this time minus one hour"
   exit 0
fi

set -x

#not needed for AOD 
#if [ ! -f ${JEDI_DIR}/convertstate/re-staggered_UV.fv_core.res.nc ]; then
#  echo "Error: D-grid wind file missing"
#  exit 1
#fi

cd ${JEDI_DIR}

#Rename the y axis here because the jedi envar task returns the wrong name (no longer needed?)
#ncrename -d yaxis_1,yaxis_2 -v yaxis_1,yaxis_2 ${PREFIX}.fv_core.res.nc
#ncatted -a long_name,yaxis_2,o,c,yaxis_2 ${PREFIX}.fv_core.res.nc

#shouldn't be needed for AOD
#copy u,v from re-stagger file into lightning.fv_core.res.nc
#ncks -v u,v convertstate/re-staggered_UV.fv_core.res.nc -O backup.re-stagger.fv_core.res.nc
#ncks -A -v u,v backup.re-stagger.fv_core.res.nc ${PREFIX}.fv_core.res.nc

#Rename the y axis here because the jedi envar task returns the wrong name (no longer needed?)
ncrename -d yaxis_1,yaxis_2 -v yaxis_1,yaxis_2 ${PREFIX}.fv_core.res.nc
ncatted -a long_name,yaxis_2,o,c,yaxis_2 ${PREFIX}.fv_core.res.nc

#processing below here modified from Jeff Duda's JEDI DbZ code and Blake Allen's JEDI FED code
yyyymmdd_hhmm=`date -d "${ATIME:0:8} ${ATIME:8:4}" +%Y%m%d.%H%M`
dyn_file=${JEDI_DIR}/${PREFIX}.fv_core.res.nc
phy_file=${JEDI_DIR}/${PREFIX}.fv_tracer.res.nc
phys_fields=(sphum smoke dust coarsepm)
dyn_fields=(T delp phis)

if [ -f ${JEDI_DIR}/fv_core.temp.nc ]; then
   rm ${JEDI_DIR}/fv_core.temp.nc
fi

#maybe not needed for AOD? (actually, we need the fv_core.temp.nc file)
ncrename -v .w,W -v .DELP,delp -v .t,T ${dyn_file} ${JEDI_DIR}/fv_core.temp.nc
err=$?
if [ ${err} -ne 0 ]; then
   echo "Error running ncrename on ${dyn_file}"
   exit ${err}
fi

for p in ${phys_fields[@]}; do
   ncatted -a checksum,${p},d,, -O ${phy_file}
   err=$?
   if [ ${err} -ne 0 ]; then
      echo "Error running ncatted on ${phy_file}"
      exit ${err}
   fi
done

for d in ${dyn_fields[@]}; do
   ncatted -a checksum,${d},d,, -O ${JEDI_DIR}/fv_core.temp.nc
   err=$?
   if [ ${err} -ne 0 ]; then
      echo "Error running ncatted on ${JEDI_DIR}/fv_core.temp.nc"
   fi
done

#Unclear if the file we want here should come from the previous hour
#This is because the process_smoke tasks updte the smoke fields at the start of each cycle.
#OTOH, the AOD DA acts on those updated smoke fields, and thus replacing the M1H fields
#with the JEDI-updated fields should give the same result as  replacing the fields output by process_smoke
#On the other other hand, this scripts exits at the beginning of spin-up (03Z and 15Z), and that is the only
#time process_smoke_spinup alters the fields (to continuously cycle smoke from the prior prod cycle). process_smoke
#has no need to update the model fields aside from those initial hours of spinup cycles.
#Going to stick with modifying M1H data for now..
#Question: What about updates from other tasks, like conventional DA w/ GSI and the cloud analysis? 

#Won't using the M1H data keep those updates from being included?
#actually, everything will be included so long as we copy everything that is updated over from the newly creted files.
hour=${ATIME:8:2}
if [ ${CYCLE_TYPE} == "prod" ]; then
   DEST_ROOT=${DEST_DIR}/fcst_fv3lam/INPUT
   if [[ ${hour} == "09" ]] || [[ ${hour} == "21" ]]; then
      nwges_dir=${NWGES_ROOT_M1H}/fcst_fv3lam_spinup/RESTART
   else
      nwges_dir=${NWGES_ROOT_M1H}/fcst_fv3lam/RESTART
   fi
elif [ ${CYCLE_TYPE} == "spinup" ]; then
   DEST_ROOT=${DEST_DIR}/fcst_fv3lam_spinup/INPUT
   nwges_dir=${NWGES_ROOT_M1H}/fcst_fv3lam_spinup/RESTART
else
   echo "improper value for \$CYCLE_TYPE (must be either \"prod\" or \"spinup\""
   exit 3
fi

# Apply updates to dynamics file
ncks -c -x -v T,delp,phis ${nwges_dir}/${yyyymmdd_hhmm}00.fv_core.res.tile1.nc -O ${DEST_ROOT}/backup_core.nc
err=$?
if [ ${err} -ne 0 ]; then
   echo "ncks exited with error code ${err}"
   exit ${err}
fi
vlist=""
for d in ${dyn_fields[@]}; do
   vlist=${vlist}${d}","
done
ncks -C -v ${vlist::-1} ${JEDI_DIR}/fv_core.temp.nc -A ${DEST_ROOT}/backup_core.nc
rm ${JEDI_DIR}/fv_core.temp.nc
mv ${DEST_ROOT}/backup_core.nc ${DEST_ROOT}/fv_core.res.tile1.nc

# Append variables to RRFS physics restart file (can't do this earlier because I need the $nwges_dir from 1 h prior from the above code first)
vlist=""
script=""
for p in ${phys_fields[@]}; do
   vlist=${vlist}${p}","
   script=${script}"$p=float(${p});"
done

# Change variable types from "double" to "float"
ncap2  -O -s "${script::-1}" ${phy_file} ${phy_file}

#copy updated physics data to final tracer file
ncks -C  -v ${vlist::-1} ${phy_file} -A ${DEST_ROOT}/fv_tracer.res.tile1.nc

#try removing the checksums again here; not sure why it is done above since they reappear
for p in ${phys_fields[@]}; do
   ncatted -a checksum,${p},d,, -O ${DEST_ROOT}/fv_tracer.res.tile1.nc
   err=$?
   if [ ${err} -ne 0 ]; then
      echo "Error running ncatted on ${phy_file}"
      exit ${err}
   fi
done

for d in ${dyn_fields[@]}; do
   ncatted -a checksum,${d},d,, -O  ${DEST_ROOT}/fv_core.res.tile1.nc
   err=$?
   if [ ${err} -ne 0 ]; then
      echo "Error running ncatted on ${JEDI_DIR}/fv_core.temp.nc"
   fi
done


if [ ${err} -ne 0 ]; then
   echo "ncks exited with error code ${err}"
   exit ${err}
fi
