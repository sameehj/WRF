# install dependencies
spack install -y parallel-netcdf
spack install -y netcdf-c
spack install -y netcdf-fortran
spack install -y jasper
spack install -y libpng
spack install -y adios2 +python
spack install -y py-matplotlib


# fix for netcdf-c and netcdf-fortran
NETCDF=$(spack location -i netcdf-fortran)
NETCDF_C=$(spack location -i netcdf-c)
ln -sf $NETCDF_C/include/*  $NETCDF/include/
ln -sf $NETCDF_C/lib/*  $NETCDF/lib/


# load dependencies
spack load openmpi
spack load parallel-netcdf
spack load netcdf-c
spack load netcdf-fortran
spack load jasper
spack load libpng
spack load adios2 +python


# environment varirables
export NETCDF=$(spack location -i netcdf-fortran)
export PNETCDF=$(spack location -i parallel-netcdf)
export JASPERINC=$(spack location -i jasper)/include
export JASPERLIB=$(spack location -i jasper)/lib
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRFIO_NCD_NO_LARGE_FILE_SUPPORT=0
export ADIOS2INC=$(adios2-config --fortran-flags)
export ADIOS2LIB=$(adios2-config --fortran-libs)


# gcc10 fix 
export FCFLAGS='-w -O2 -ffixed-line-length-0  -fallow-argument-mismatch -fallow-invalid-boz'
export FFLAGS='-w -O2 -ffree-line-length-0 -fallow-argument-mismatch -fallow-invalid-boz'

# cd and configure
cd ..
./configure

# compile
./compile -j 4 em_real 2>&1 | tee wrf_compile.log
