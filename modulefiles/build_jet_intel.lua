help([[
This module loads libraries for building the RRFS workflow on
the NOAA RDHPC machine Jet using Intel-2022.1.2
]])

whatis([===[Loads libraries needed for building the RRFS workflow on Jet ]===])

prepend_path("MODULEPATH", "/contrib/spack-stack/spack-stack-1.5.1/envs/gsi-addon-rocky8/install/modulefiles/Core")

load(pathJoin("stack-intel", os.getenv("stack_intel_ver") or "2021.5.0"))
load(pathJoin("stack-intel-oneapi-mpi", os.getenv("stack_impi_ver") or "2021.5.1"))
load(pathJoin("cmake", os.getenv("cmake_ver") or "3.23.1"))

load("rrfs_common")
load("wgrib2/2.0.8")
load("libyaml/0.2.5")

setenv("prod_util_ROOT","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15")
prepend_path("PATH","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin")
setenv("UTILROOT","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15")
setenv("MDATE","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/mdate")
setenv("NDATE","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/ndate")
setenv("NHOUR","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/nhour")
setenv("FSYNC","/mnt/lfs5/BMC/nrtrr/FIX_EXEC_MODULE/prod_util/2.0.15/bin/fsync_file")


unload("python/3.10.8")
unload("fms/2023.02.01")
unload("g2tmpl/1.10.2")

setenv("g2tmpl_ROOT","/mnt/lfs5/BMC/wrfruc/bjallen/JEDI-AOD/g2tmpl/install/")
setenv("g2tmpl_INC","/mnt//lfs5/BMC/wrfruc/bjallen/JEDI-AOD/g2tmpl/install/include/")
setenv("FMS_ROOT","/mnt/lfs5/BMC/wrfruc/bjallen/JEDI-AOD/fms.2024.01/install/")

setenv("CMAKE_C_COMPILER","mpiicc")
setenv("CMAKE_CXX_COMPILER","mpiicpc")
setenv("CMAKE_Fortran_COMPILER","mpiifort")
setenv("CMAKE_Platform","jet.intel")
setenv("BLENDINGPYTHON","/contrib/miniconda3/4.5.12/envs/pygraf/bin/python")
