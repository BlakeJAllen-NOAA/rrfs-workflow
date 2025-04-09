MACHINE="jet"
version="v0.7.7"
#RESERVATION="rrfsdet"
EXPT_BASEDIR="/lfs5/BMC/wrfruc/bjallen/JEDI-AOD/RRFS_AOD_ParkFire_DAexp1/${version}"
EXPT_SUBDIR="RRFS_CONUS_3km"

PREDEF_GRID_NAME=RRFS_CONUS_3km

. set_rrfs_config_general.sh
. set_rrfs_config_SDL_VDL_MixEn.sh

#DO_ENSEMBLE="TRUE"
#DO_ENSFCST="TRUE"
DO_DACYCLE="TRUE"
DO_SURFACE_CYCLE="FALSE"
DO_SPINUP="TRUE"
DO_SAVE_INPUT="TRUE"
DO_POST_SPINUP="FALSE"
DO_POST_PROD="TRUE"
DO_RETRO="TRUE"
DO_NONVAR_CLDANAL="FALSE"
DO_ENVAR_RADAR_REF="FALSE"
DO_SMOKE_DUST="TRUE"
EBB_DCYCLE="2"
DO_PM_DA="FALSE"
DO_REFL2TTEN="FALSE"
RADARREFL_TIMELEVEL=(0)
FH_DFI_RADAR="0.0,0.25,0.5"
DO_SOIL_ADJUST="TRUE"
DO_RADDA="TRUE"
DO_BUFRSND="FALSE"
USE_FVCOM="FALSE"
PREP_FVCOM="FALSE"
USE_CLM="TRUE"
DO_PARALLEL_PRDGEN="FALSE"
DO_GSIDIAG_OFFLINE="FALSE"
DO_UPDATE_BC="FALSE"
DO_JEDI_GLM_DA="FALSE"
DO_JEDI_AOD_DA="TRUE"

### NOTE: config_defaults.sh contains a lot of documentation for the options ###

EXTRN_MDL_ICS_OFFSET_HRS="0" #maybe i'll need to change this and the LCBS offsetto account for the 03Z start? 3 matches the value in the lightning retro config
LBC_SPEC_INTVL_HRS="1"
EXTRN_MDL_LBCS_OFFSET_HRS="0" #6 is the value here in the lightning retro. I'm not sure why that is changed from the original value of 0, though (probably GFS related?).
BOUNDARY_LEN_HRS="51"
BOUNDARY_LONG_LEN_HRS="51"
BOUNDARY_PROC_GROUP_NUM="6"

# avaialble retro period:
# 20210511-20210531; 20210718-20210801
#DATE_FIRST_CYCL="20210718"
#DATE_LAST_CYCL="2020720"
DATE_FIRST_CYCL="20240720"
DATE_LAST_CYCL="20240730"
CYCL_HRS=( "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" )
CYCL_HRS_SPINSTART=("03" "15")
CYCL_HRS_PRODSTART=("09" "21")

CYCLEMONTH="07"
CYCLEDAY="20-30"

STARTYEAR=${DATE_FIRST_CYCL:0:4}
STARTMONTH=${DATE_FIRST_CYCL:4:2}
STARTDAY=${DATE_FIRST_CYCL:6:2}
STARTHOUR="00"
ENDYEAR=${DATE_LAST_CYCL:0:4}
ENDMONTH=${DATE_LAST_CYCL:4:2}
ENDDAY=${DATE_LAST_CYCL:6:2}
ENDHOUR="23"

INITIAL_CYCLEDEF="${DATE_FIRST_CYCL}0300 ${DATE_LAST_CYCL}2300 12:00:00"
BOUNDARY_CYCLEDEF="00 03,09,15,21 ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#BOUNDARY_LONG_CYCLEDEF="00 09,21  ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
PROD_CYCLEDEF="00 01,02,04,05,07,08,10,11,13,14,16,17,19,20,22,23 20-30 ${CYCLEMONTH} ${STARTYEAR} *"
PRODLONG_CYCLEDEF="00 00,03,06,09,12,15,18,21  20-30 ${CYCLEMONTH} ${STARTYEAR} *"

if [[ $DO_SPINUP == "TRUE" ]] ; then
  SPINUP_CYCLEDEF="00 03-08,15-20 ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
fi

PREEXISTING_DIR_METHOD="upgrade"

#INITIAL_CYCLEDEF="${DATE_FIRST_CYCL}0300 ${DATE_LAST_CYCL}2300 24:00:00" #is the last number the cycle length? it was 1:00:00 originally
#BOUNDARY_CYCLEDEF="00 00  ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#BOUNDARY_LONG_CYCLEDEF="00 00 ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#PROD_CYCLEDEF="00 03,09,15  ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#PRODLONG_CYCLEDEF="00 21  ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#ARCHIVE_CYCLEDEF="${DATE_FIRST_CYCL}0700 ${DATE_LAST_CYCL}2300 24:00:00"
#if [[ $DO_SPINUP == "TRUE" ]] ; then
#  SPINUP_CYCLEDEF="00 03,09,15 ${CYCLEDAY} ${CYCLEMONTH} ${STARTYEAR} *"
#fi

FCST_LEN_HRS="24"
FCST_LEN_HRS_SPINUP="1"
FCST_LEN_HRS_CYCLES=(24 1 1 24 1 1 24 1 1 24 1 1 24 1 1 24 1 1 24 1 1 24 1 1)
#for i in {0..23}; do FCST_LEN_HRS_CYCLES[$i]=3; done
#for i in {0..23..3}; do FCST_LEN_HRS_CYCLES[$i]=12; done
DA_CYCLE_INTERV="1"
RESTART_INTERVAL="1"
RESTART_INTERVAL_LONG="1"
## set up post
POSTPROC_LEN_HRS="1"
POSTPROC_LONG_LEN_HRS="24"
# 15 min output upto 18 hours
#OUTPUT_FH="1 -1"
#OUTPUT_FH="0.0 0.25 0.50 0.75 1.0 1.25 1.50 1.75 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0"

USE_RRFSE_ENS="FALSE"
CYCL_HRS_HYB_FV3LAM_ENS=("00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23")

SST_update_hour=01 
GVF_update_hour=04
SNOWICE_update_hour=01
SOIL_SURGERY_time=2022020104
netcdf_diag=.true.
binary_diag=.false.
WRTCMP_output_file="netcdf_parallel"
WRTCMP_ideflate="1"
WRTCMP_quantize_nsd="18"

regional_ensemble_option=1   # 5 for RRFS ensemble

EXTRN_MDL_NAME_ICS="RAP"
EXTRN_MDL_NAME_LBCS="RAP"
EXTRN_MDL_DATE_JULIAN="TRUE"

envir="para"

NET="rrfs_b"
TAG="c3v79"

ARCHIVEDIR="/1year/BMC/wrfruc/rrfs_b"
NCL_REGION="conus"
MODEL="rrfs_b"
RUN="rrfs"

. set_rrfs_config.sh

STMP="${EXPT_BASEDIR}/stmp"  # Path to directory STMP that mostly contains input files.
PTMP="${EXPT_BASEDIR}/ptmp"  # Path to directory STMP that mostly contains input files.
NWGES="${EXPT_BASEDIR}/nwges"  # Path to directory NWGES that save boundary, cold initial, restart files
if [[ ${regional_ensemble_option} == "5" ]]; then
  RRFSE_NWGES="YourOwnSpace/${version}/nwges"  # Path to RRFSE directory NWGES that mostly contains ensemble restart files for GSI hybrid.
  NUM_ENS_MEMBERS=30     # FV3LAM ensemble size for GSI hybrid analysis
  CYCL_HRS_PRODSTART_ENS=( "07" "19" )
  DO_ENVAR_RADAR_REF="TRUE"
fi
