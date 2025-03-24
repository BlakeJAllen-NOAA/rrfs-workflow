help([[
This module loads python environement for running the RRFS workflow on
the NOAA RDHPC machine Jet
]])

whatis([===[Loads libraries needed for running the RRFS workflow on Jet ]===])

load("rocoto")

prepend_path("MODULEPATH", "/contrib/spack-stack/spack-stack-1.5.1/envs/gsi-addon-rocky8//install/modulefiles/Core")
load(pathJoin("stack-intel", os.getenv("stack_intel_ver") or "2021.5.0"))
load(pathJoin("stack-intel-oneapi-mpi", os.getenv("stack_impi_ver") or "2021.5.1"))
load(pathJoin("crtm", os.getenv("crtm_ver") or "2.4.0"))
load(pathJoin("libyaml", os.getenv("libyaml_ver") or "0.2.5"))

unload("python/3.10.8")
unload("fms/2023.02.01")
unload("g2tmpl/1.10.2")

setenv("prod_util_ROOT","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15")
prepend_path("PATH","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin")
setenv("UTILROOT","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15")
setenv("MDATE","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/mdate")
setenv("NDATE","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/ndate")
setenv("NHOUR","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/nhour")
setenv("FSYNC","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/fsync_file")

setenv("g2tmpl_ROOT","/mnt/lfs5/BMC/wrfruc/bjallen/JEDI-AOD/g2tmpl/install/")
setenv("g2tmpl_INC","/mnt//lfs5/BMC/wrfruc/bjallen/JEDI-AOD/g2tmpl/install/")
setenv("FMS_ROOT","/mnt/lfs5/BMC/wrfruc/bjallen/JEDI-AOD/fms.2024.01/install/")

prepend_path("MODULEPATH","/contrib/miniconda3/modulefiles")
load(pathJoin("miniconda3", os.getenv("miniconda3_ver") or "4.5.12"))
 
load(pathJoin("py-f90nml", os.getenv("py-f90nml") or "1.4.3"))


if mode() == "load" then
   LmodMsgRaw([===[Please do the following to activate conda:
       > conda activate /home/Johana.Romero-Alvarez/miniconda3/envs/interpol_esmpy
]===])
end
