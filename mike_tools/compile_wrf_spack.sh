# install dependencies
spack install -y parallel-netcdf ^openmpi
spack install -y netcdf-c ^openmpi@master ^hdf5 +fortran
spack install -y netcdf-fortran ^openmpi ^hdf5 +fortran
spack install -y jasper
spack install -y libpng
spack install -y adios2 +python ^python +tkinter
spack install -y py-matplotlib ^python +tkinter
echo 


# fix for netcdf-c and netcdf-fortran (need root)
NETCDF=$(spack location -i netcdf-fortran ^openmpi@master ^hdf5 +fortran)
NETCDF_C=$(spack location -i netcdf-c ^openmpi@master ^hdf5 +fortran)
ln -sf $NETCDF_C/include/*  $NETCDF/include/
ln -sf $NETCDF_C/lib/*  $NETCDF/lib/


# load dependencies
spack load openmpi
spack load parallel-netcdf ^openmpi
spack load netcdf-c ^openmpi ^hdf5 +fortran
spack load netcdf-fortran ^openmpi ^hdf5 +fortran
spack load jasper
spack load libpng
spack load adios2 +python ^python +tkinter
echo


# environment varirables
export NETCDF=$(spack location -i netcdf-fortran ^hdf5 +fortran)
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

# configure
#cd /path/to/wrf/src
./configure

# compile
./compile em_real 2>&1 | tee wrf_compile.log
